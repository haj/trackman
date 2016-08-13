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
  # ASSOCIATION
  belongs_to :plan
  has_many :users, :dependent => :destroy
  has_many :cars, :dependent => :destroy
  has_many :devices, :dependent => :destroy
  has_many :simcards, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :subscriptions
  has_many :alarm_notifications

  # VALIDATION
  validates :name, uniqueness: { case_sensitive: false }, presence: true
  validates :subdomain, uniqueness: { case_sensitive: false }, presence: true

  # CALLBACK
  before_save :setup_default_plan
  before_save { |company| company.subdomain = company.subdomain.downcase }

  # INSTANCE METHOD
  def setup_default_plan
    self.plan_id = Plan.first.id if Plan.first
  end

  def current_plan
    subscription = self.subscriptions.where(active: true).first
    
    subscription ? subscription.plan : Plan.first
  end

  def cancel_active_subscriptions
    # get the active subscription
    subscriptions.where(active: true).each { |subscription| subscription.cancel }
  end
end
