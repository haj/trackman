# == Schema Information
#
# Table name: companies
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  subdomain  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  plan_id    :integer
#  time_zone  :string(255)
#

class Company < ActiveRecord::Base

	before_save { |company| company.subdomain = company.subdomain.downcase }


	validates :name, uniqueness: { case_sensitive: false }
	validates :subdomain, uniqueness: { case_sensitive: false }

	has_many :users, :dependent => :destroy 
	has_many :cars, :dependent => :destroy
	has_many :devices, :dependent => :destroy
	has_many :simcards, :dependent => :destroy
	has_many :groups, :dependent => :destroy
	belongs_to :plan
	has_many :subscriptions
	has_many :alarm_notifications

	before_save :setup_plan

  	def setup_plan
    	if !Plan.first.nil?
			self.plan_id = Plan.first.id
		end	
  	end

  	def current_plan
  		subscription = self.subscriptions.where(active: true).first
  		if subscription
  			return subscription.plan
  		else 
  			Plan.first
  		end
  	end

	def cancel_active_subscriptions
		# get the active subscription
		self.subscriptions.where(active: true).each { |subscription| subscription.cancel }
	end

end
