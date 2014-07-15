class Pricing < ActiveRecord::Base
	belongs_to :plan


	def generate_paymill_record
		Paymill::Offer.create amount: self.amount , currency: "USD", interval: self.billable_days , name: self.plan.name
	end
end
