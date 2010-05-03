class ContributionTransaction < ActiveRecord::Base
  belongs_to :contribution
  serialize :params
  cattr_accessor :gateway
 
  class << self
    def approve(amount, credit_card, options = {})
      process('approve', amount) do |gw|
        gw.purchase(amount, credit_card, options)
      end
    end
    
    def refund(amount, authorization, options = {})
      process('refund', amount) do |gw|
        gw.credit(amount, authorization, options)
      end
    end
    
    private
      def process(action, amount = nil)
        result = ContributionTransaction.new
        result.amount = amount
        result.action = action
      
        begin
          response = yield gateway
          result.success   = response.success?
          result.reference = response.authorization
          result.message   = response.message
          result.params    = response.params
          result.test      = response.test?
        rescue ActiveMerchant::ActiveMerchantError => e
          result.success   = false
          result.reference = nil
          result.message   = e.message
          result.params    = {}
          result.test      = gateway.test?
        end
      
        result
      end
  end
end