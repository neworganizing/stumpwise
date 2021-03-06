# Copyright (c) 2010-2011 ProgressBound, Inc.
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'timeout'
require 'mongo'
require 'bson'

module Rack
  class GridFSConnectionError < StandardError ; end
  
  class GridFS
    attr_reader :hostname, :port, :database, :prefix, :db, :username, :password
    
    def initialize(app, options = {})
      options = {
        :hostname => 'localhost', 
        :prefix   => 'gridfs',
        :port     => Mongo::Connection::DEFAULT_PORT
      }.merge(options)

      @app        = app
      @hostname   = options[:hostname]
      @port       = options[:port]
      @database   = options[:database]
      @prefix     = options[:prefix]
      @username   = options[:username]
      @password   = options[:password]
      @db         = nil

      connect!
    end

    def call(env)
      request = Rack::Request.new(env)
      # regex allows us to append filenames to the hash url
      # i.e. http://example.com/gridfs/4c7e389a14e3bc1bd1000002/My-Photo.jpg
      if request.path_info =~ /^\/#{prefix}\/([^\/]+)/
        gridfs_request($1)
      else
        @app.call(env)
      end
    end

    def gridfs_request(id)
      file = Mongo::Grid.new(db).get(BSON::ObjectId.from_string(id))
      [
        200, 
        {
          'Content-Type'        => file.content_type,
          'Content-Length'      => file.file_length.to_s,
          'Content-Disposition' => "inline;filename=#{file.filename}",
          # Grid FS files cannot be modified, so we can safely give them never
          # expiring headers & use their id as an Etag
          'Expires'             => 'Sat, 01 Jan 2050 00:00:00 GMT',
          'Etag'                => id
        }, 
        [file.read]
      ]
    rescue Mongo::GridError, BSON::InvalidObjectID
      [404, {'Content-Type' => 'text/plain'}, ['File not found.']]
    end
    
    private
      def connect!
        Timeout::timeout(10) do
          @db = Mongo::Connection.new(hostname, port).db(database)
          if username && password
            @db.authenticate(username, password)
          end
        end
      rescue Exception => e
        raise Rack::GridFSConnectionError, "Unable to connect to the MongoDB server (#{e.to_s})"
      end
  end
end