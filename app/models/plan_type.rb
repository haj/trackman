class PlanType < ActiveRecord::Base
	has_many :plans
	has_many :subscriptions
	has_and_belongs_to_many :features
end
