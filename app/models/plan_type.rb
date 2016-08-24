# == Schema Information
#
# Table name: plan_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class PlanType < ActiveRecord::Base
  # ASSOCIATION
  has_many :plans
  has_many :subscriptions
  has_and_belongs_to_many :features

  # VALIDATION
  validates :name, presence: true
end
