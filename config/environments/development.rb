# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

#config.after_initialize {
#  ActiveSupport::Dependencies.load_once_paths.delete(File.join(Rails.root, 'lib'))
#}

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.default_charset = "utf-8"
config.action_mailer.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => '587',
  :enable_starttls_auto => true,
  :domain => "progressbound.com",
  :authentication => :plain,
  :user_name => "dev-server@progressbound.com",
  :password => "0xZ2NSqrGcZrSPBqseTN"
}

config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
end

config.to_prepare do
  ContributionTransaction.gateway = 
    ActiveMerchant::Billing::Base.gateway('braintree').new(
      :login => 'demo',
      :password => 'password'
    )
end

SslRequirement.disable_ssl_check = true
BASE_URL = "localdev.com"
HOST = "localdev.com:3000"

config.middleware.use "SetCookieDomain", ".localdev.com"