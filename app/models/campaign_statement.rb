# == Schema Information
# Schema version: 20100916062732
#
# Table name: campaign_statements
#
#  id              :integer(4)      not null, primary key
#  site_id         :integer(4)
#  disbursed_on    :date
#  funds_available :date
#  starting        :datetime
#  ending          :datetime
#  total_raised    :decimal(8, 2)   default(0.0)
#  total_fees      :decimal(8, 2)   default(0.0)
#  total_due       :decimal(8, 2)   default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#

class CampaignStatement < ActiveRecord::Base
  belongs_to :site
  has_many :contributions
end
