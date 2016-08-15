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

  def save_with_payment
    begin
      if valid?
        client          = PaymillServices.create_client(email, name)
        payment         = PaymillServices.create_payment(paymill_card_token, client.id)
        subscription    = PaymillServices.create_subscription(plan.paymill_id, client.id, payment.id)
        self.paymill_id = subscription.id
        self.active     = true
        save!
      end

    rescue Paymill::PaymillError => e
      logger.error "Paymill error while creating customer: #{e.message}"
      errors.add :base, "There was a problem with your credit card. Please try again."
    end
  end

  def cancel 
    PaymillServices.cancel(self.paymill_id, self.id)
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
