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

ENV["RAILS_ENV"] = "test"

I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = "leave me alone"

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# require 'shoulda'
# require 'matchy'
require 'blueprints'
# require 'fakeweb'
# require 'webrat'
require 'authlogic/test_case'

Webrat.configure do |config|
  config.mode = :rails
end

class ActiveSupport::TestCase
  # Commented out for Rails 3
  # self.use_transactional_fixtures = true
  # self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  setup { Sham.reset }

  def compact_html(str)
    str.squish!.gsub(/> </, '><')
  end
  
  def assert_html_equal(html1,html2)
    assert_equal compact_html(html1), compact_html(html2)
  end
  
  def assert_blank(attribute)
    assert attribute.blank?, "#{attribute} was expected to be blank"
  end
  
  def assert_not_blank(attribute)
    assert !attribute.blank?, "#{attribute} should have had a value, but was blank"
  end
  
  def make_site_with_pages
    Site.make do |site|
      3.times { site.pages.make }
    end
  end
  
  def address(options = {})
    { :name     => 'Marc Love',
      :address1 => '2400 Market Street',
      :address2 => 'Suite 1000',
      :city     => 'San Francisco', 
      :state    => 'CA',
      :country  => 'US',
      :zip      => '94114'
    }.update(options)
  end
  
  def credit_card(options = {})
    { :number           => '4009348888881881',
      :expiration_month => '1',
      :expiration_year  => "#{ Time.now.year + 1 }",
      :cvv => '123'
    }.update(options)
  end
  
  def setup_session_domain
    @request.env['rack.session.options'] = {:domain => ".stumpwise-local.com"}
  end
  
  def login_as(fixture_name)
    setup_session_domain
    activate_authlogic
    UserSession.create(users(fixture_name))
  end
  
  def on_site(fixture_name)
    @controller.stubs(:current_site).returns(sites(fixture_name))
  end
  
  def gateway_sale_result(result)
    if result == :success
      Braintree::SuccessfulResult.new(
        :transaction => Braintree::Transaction._new({
          :id => "j26hdw",
          :type => "sale", 
          :amount => "100.0", 
          :status => "authorized", 
          :created_at => Time.parse("Sun Jun 06 06:33:21 UTC 2010"),
          :updated_at => Time.parse("Sun Jun 06 06:33:24 UTC 2010"),
          :credit_card => {
            :token => nil, 
            :bin => "400934",
            :last_4 => "1881",
            :card_type => "Visa",
            :expiration_month => "05",
            :expiration_year => "2012",
            :cardholder_name => nil,
            :customer_location => "US"
          },
          :customer => {
            :id => nil,
            :first_name => nil,
            :last_name => nil,
            :email => nil,
            :company => nil,
            :website => nil,
            :phone => nil,
            :fax => nil
          }
        })
      )
    else
      Braintree::ErrorResult.new({
        :params => {}, 
        :verification => {}, 
        :transaction => {}, 
        :errors => {
          :scope => {
            :errors => [{:attribute => "transaction", :code => "81528", :message => "The amount is too large."}]
          }
        }
      })
    end
  end
  
  def gateway_void_result(result)
    if result == :success
      Braintree::SuccessfulResult.new({
        :transaction => Braintree::Transaction._new({
          :id => "j26hdw",
          :type => "sale", 
          :amount => "100.0", 
          :status => "voided", 
          :created_at => Time.parse("Sun Jun 06 06:33:21 UTC 2010"),
          :updated_at => Time.parse("Sun Jun 06 06:38:18 UTC 2010"),
          :credit_card => {
            :token => nil, 
            :bin => "400934",
            :last_4 => "1881",
            :card_type => "Visa",
            :expiration_month => "05",
            :expiration_year => "2012",
            :cardholder_name => nil,
            :customer_location => "US"
          },
          :customer => {
            :id => nil,
            :first_name => nil,
            :last_name => nil,
            :email => nil,
            :company => nil,
            :website => nil,
            :phone => nil,
            :fax => nil
          }
        })
      })
    else
      Braintree::ErrorResult.new({
        :params => {}, 
        :verification => {}, 
        :transaction => {}, 
        :errors => {
          :scope => {
            :errors => [{:attribute => "transaction", :code => "91504", :message => "Cannot be voided."}]
          }
        }
      })
    end
  end
  
  def gateway_refund_result(result)
    if result == :success
      Braintree::SuccessfulResult.new({
        :new_transaction => Braintree::Transaction._new({
          :id => "gxgpyb",
          :type => "credit", 
          :amount => "100.0", 
          :status => "submitted_for_settlement", 
          :created_at => Time.parse("Sun Jun 06 07:33:21 UTC 2010"),
          :updated_at => Time.parse("Sun Jun 06 07:38:18 UTC 2010"),
          :credit_card => {
            :token => nil, 
            :bin => "400934",
            :last_4 => "1881",
            :card_type => "Visa",
            :expiration_month => "05",
            :expiration_year => "2012",
            :cardholder_name => nil,
            :customer_location => "US"
          },
          :customer => {
            :id => nil,
            :first_name => nil,
            :last_name => nil,
            :email => nil,
            :company => nil,
            :website => nil,
            :phone => nil,
            :fax => nil
          }
        })
      })
    else
      Braintree::ErrorResult.new({
        :params => {}, 
        :verification => {}, 
        :transaction => {}, 
        :errors => {
          :scope => {
            :errors => [{:attribute => "transaction", :code => "91521", :message => "The refund amount is too large."}]
          }
        }
      })
    end
  end
  
  def multiple_gateway_error_result
    Braintree::ErrorResult.new({
      :params => {}, 
      :verification => {}, 
      :transaction => {:processor_response_text => "Processor Declined"}, 
      :errors => {
        :scope => {
          :errors => [{:attribute => "transaction", :code => "81528", :message => "The amount is too large."}],
          :second_scope => {
            :errors => [{:attribute => "credit_card", :code => "91701", :message => "The billing address doesn't match."}],
          }
        }
      }
    })
  end
  
  def gateway_customer_create_result(result)
    if result == :success
      Braintree::SuccessfulResult.new({
        :customer => Braintree::Customer._new({
          :id => "131866",
          :first_name => "Charity",
          :last_name => "Smith",
          :company => nil,
          :email => nil,
          :fax => nil,
          :phone => nil,
          :website => nil,
          :created_at => Time.parse("Tue Jul 06 10:10:12 UTC 2010"),
          :updated_at => Time.parse("Tue Jul 06 10:10:13 UTC 2010"),
          :addresses => [],
          :credit_cards => [
            {
              :token => "fydb",
              :customer_id => "131866",
              :cardholder_name => "",
              :card_type => "MasterCard",
              :bin => "510510",
              :last_4 => "5100",
              :expiration_month => "05",
              :expiration_year => "2012", 
              :billing_address => nil,
              :created_at => Time.parse("Tue Jul 06 10:10:12 UTC 2010"),
              :updated_at => Time.parse("Tue Jul 06 10:10:12 UTC 2010")
            }
          ]
        })
      })
    else
      Braintree::ErrorResult.new({
        :params => {}, 
        :verification => {}, 
        :transaction => {}, 
        :errors => {
          :scope => {
            :errors => [{:attribute => "credit_card", :code => "81706", :message => "CVV is required."}]
          }
        }
      })
    end
  end
  
  def gateway_subscription_create_result(result)
    if result == :success
      Braintree::SuccessfulResult.new({
        :subscription => Braintree::Subscription._new({
          :id => "9td64b",
          :price => "99.00",
          :plan_id => "basic",
          :first_billing_date => "2010-07-06",
          :next_billing_date => "2010-08-06",
          :billing_period_start_date => "2010-07-06",
          :billing_period_end_date => "2010-08-05",
          :merchant_account_id => "ProgressBound",
          :trial_period => false,
          :status => "Active",
          :failure_count => 0,
          :payment_method_token => "7z76",
          :trial_duration => nil,
          :trial_duration_unit => "day",
          :transactions => []
        })
      })
    else
      Braintree::ErrorResult.new({
        :params => {}, 
        :verification => {}, 
        :transaction => {}, 
        :errors => {
          :scope => {
            :errors => [{:attribute => "subscription", :code => "91903", :message => "Payment method token is invalid."}]
          }
        }
      })
    end
  end
end
