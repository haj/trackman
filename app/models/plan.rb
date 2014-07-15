class Plan < ActiveRecord::Base
	belongs_to :plan_type
	has_many :companies
	has_many :subscriptions

	def create_offer
		if paymill_id.nil?
			offer = Paymill::Offer.create amount: self.price.to_i, currency: self.currency, interval: "#{self.interval} DAY", name: self.name
			if offer
				self.update_attribute(:paymill_id, offer.id)
			end		 
		end
	end

	def self.all_offers
		Paymill::Offer.all
	end

	# accessors

	def name
		self.plan_type.name
	end

end
