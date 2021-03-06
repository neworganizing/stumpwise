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

# == Schema Information
# Schema version: 20100916062732
#
# Table name: users
#
#  id                      :integer(4)      not null, primary key
#  email                   :string(255)     not null
#  first_name              :string(255)
#  last_name               :string(255)
#  crypted_password        :string(255)
#  password_salt           :string(255)
#  persistence_token       :string(255)     not null
#  single_access_token     :string(255)
#  perishable_token        :string(255)
#  created_at              :datetime
#  updated_at              :datetime
#  login_count             :integer(4)      default(0), not null
#  failed_login_count      :integer(4)      default(0), not null
#  last_request_at         :datetime
#  current_login_at        :datetime
#  last_login_at           :datetime
#  current_login_ip        :string(255)
#  last_login_ip           :string(255)
#  super_admin             :boolean(1)
#  time_zone               :string(255)     default("Pacific Time (US & Canada)")
#  accepted_campaign_terms :boolean(1)
#

class User < ActiveRecord::Base
  attr_protected :super_admin
  
  acts_as_authentic do |c|
    c.merge_validates_length_of_password_field_options :minimum => 8
  end
  
  has_many :owned_sites,        :foreign_key => 'owner_id', :class_name => 'Site'
  has_many :administratorships, :foreign_key => 'administrator_id', :dependent => :destroy
  has_many :administered_sites, :through => :administratorships, :source => :site
  
  validates_uniqueness_of :email, :case_sensitive => false
  validates_length_of :email, :within => 6..100, :allow_blank => false
  validates_format_of :email, :with => RegEmailOk, :allow_blank => false
  validates_presence_of :first_name, :last_name, {:message => "is required"}
  
  def to_liquid
    UserDrop.new(self)
  end
  
  def email=(new_email)
    new_email.downcase! unless new_email.nil?
    write_attribute(:email, new_email)
  end
  
  def name
    "#{first_name} #{last_name}"
  end
end
