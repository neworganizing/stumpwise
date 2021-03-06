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

module Stumpwise
  module Domains
    def self.included(controller)
      controller.helper_method(:current_site)
    end
  
    protected
      def current_site
        @site ||=
          if custom_domain?
            puts "Custom Domain"
            Site.find_by_custom_domain(current_domain.split(':')[0])
          elsif current_subdomain != 'www' && !current_subdomain.nil?
            puts "Subdomain"
            Site.find_by_subdomain(current_subdomain)
          else
            nil
          end
      end
      
      def custom_domain?
        false
        #current_domain != HOST
      end
  end
end