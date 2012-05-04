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

class Theme
  include MongoMapper::Document
  
  key :name,        String, :required => true
  key :version_ids, Array
  key :listed,      Boolean, :default => false
  key :default,     Boolean, :default => false
  timestamps!
  
  many :versions, :class_name => 'ThemeVersion',
                  :dependent => :destroy
  
  many :customizations, :class_name => 'ThemeCustomization',
                        :dependent => :destroy
  
  def latest_version
    versions.first({:active => true, :order => 'created_at desc'})
  end
  
  def destroy
    in_use? ? false : super
  end
  
  def layouts
    return Layout.find(:all, :conditions => {:theme_id => id})
  end

  private
    def in_use?
      Site.find(:all, :conditions => {:mongo_theme_id => self.id.to_s}).size > 0
    end
end