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
  # INI GET
  acts_as_tenant(:company)

  # validation
  validates :email, :name, :company_id, :plan_id, presence: true

  # Arre Accessor
  attr_accessor :paymill_card_token

  # Association
  belongs_to :plan
  belongs_to :company

  # Callback
  before_create :cancel_active_subscriptions, :save_with_payment
  after_create :active_subscribe

  scope :active, -> { find_by(active: true) }

  def cancel_active_subscriptions
    # schedule to cancel all active subscriptions
    subs = company.subscriptions.where(active: true)

    subs.each { |subscription| PaymillServices.cancel(subscription.paymill_id, subscription.id) } if subs.present?
  end

  def active_subscribe
    # Add this subscription to the company list of subscriptions
    company.subscriptions << self
    # Assign plan
    company.plan_id = self.plan_id
    # Save
    company.save!    
  end

  def save_with_payment
    begin
      client          = PaymillServices.create_client(email, name)
      payment         = PaymillServices.create_payment(paymill_card_token, client.id)
      subscription    = PaymillServices.create_subscription(plan.paymill_id, client.id, payment.id)
      self.paymill_id = subscription.id
      self.active     = true

    rescue Paymill::PaymillError => e
      errors.add :base, "There was a problem with your credit card. Please try again."
    end
  end

  def cancel
    PaymillServices.cancel(self.paymill_id, self.id)

    company.update_attribute(:plan_id, Plan.first.id)
  end

  class << self

    def cancel_all
      Subscription.all.each { |subscription| subscription.cancel }
    end

    def all_subscriptions
      PaymillServices.all_subscriptions
    end
  end
end
