# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  name       :string(255)
#  paymill_id :string(255)
#  created_at :datetime
#  updated_at :datetime
#  plan_id    :integer
#  company_id :integer
#  active     :boolean
#

class Subscription < ActiveRecord::Base
	attr_accessor :paymill_card_token

	belongs_to :plan
	belongs_to :company

	def save_with_payment
		if valid?
			client = Paymill::Client.create(email: email, description: name)
			Rails.logger.warn "card_token : #{paymill_card_token}"
			payment = Paymill::Payment.create(token: paymill_card_token, client: client.id)
			Rails.logger.warn "payment : #{payment}"
			subscription = Paymill::Subscription.create(offer: plan.paymill_id, client: client.id, payment: payment.id)
			Rails.logger.warn "subscription : #{subscription}"
			self.paymill_id = subscription.id
			self.active = true
			save!
		end

		rescue Paymill::PaymillError => e
			logger.error "Paymill error while creating customer: #{e.message}"
			errors.add :base, "There was a problem with your credit card. Please try again."
		false
	end

	def self.all_subscriptions
		Paymill::Subscription.all
	end

	def cancel 
		Paymill::Subscription.update_attributes self.paymill_id, cancel_at_period_end: true
		Paymill::Subscription.delete(self.paymill_id)
		self.update_attribute(:active, false)
	end

	def self.cancel_all
		Subscription.all.each { |subscription| subscription.cancel }
	end

end
