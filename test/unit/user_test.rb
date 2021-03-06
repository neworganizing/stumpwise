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

require 'test_helper'
 
class UserTest < ActiveSupport::TestCase
  setup do
    @existing_user = User.make
  end

  should_validate_presence_of :first_name, :last_name

  # Relationships
  should_have_many :owned_sites, :administered_sites
  should_have_many :administratorships, :dependent => :destroy

  # Mass assignment protections
  should_not_allow_mass_assignment_of :super_admin
  should_allow_mass_assignment_of :email, :first_name, :last_name, :password, :password_confirmation
  
  # Email formatting & uniqueness
  should_ensure_length_in_range :email, 6..100
  should_allow_values_for :email, "a@b.ly", "test@john.co.uk"
  should_not_allow_values_for :email, "notanemail", "no email"
  should_validate_uniqueness_of :email, :case_sensitive => false

  should "always store email as lower case" do
    u = User.make(:email => "F@FOOBAR.COM")
    u.email.should == 'f@foobar.com'
  end

  should "require password to be at least 8 characters long" do
    assert_no_difference 'User.count' do
      u = User.make_unsaved(:password => "1234567", :password_confirmation => "1234567")
      u.save
      assert u.errors.on(:password)
      assert u.errors.on(:password_confirmation)
    end
  end

  should "require password to be confirmed" do
    u = User.make_unsaved(:password_confirmation => "")
    u.save
    assert u.errors.on(:password_confirmation)
  end
  
  should "return a user's full name" do
    u = User.make(:first_name => "Marc", :last_name => "Love")
    assert_equal "Marc Love", u.name
  end
end