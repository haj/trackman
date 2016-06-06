# == Schema Information
#
# Table name: plans
#
#  id           :integer          not null, primary key
#  plan_type_id :integer
#  interval     :string(255)
#  currency     :string(255)
#  price        :float(24)
#  paymill_id   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Plan < ActiveRecord::Base
  # ASSOCIATION
  belongs_to :plan_type
  has_many :companies
  has_many :subscriptions

  # CALLBACKS
  after_save :create_paymill_offer

  # VALIDATION
  validates :name, :plan_type_id, :price, :interval, presence: true

  # INSTANCE METHOD
  def create_paymill_offer
    if paymill_id.nil? && self.price > 0
      offer = Paymill::Offer.create amount: self.price.to_i*100, currency: self.currency, interval: "#{self.interval} DAY", name: self.name
      if offer
        self.update_attribute(:paymill_id, offer.id)
      end    
    end
  end

  def self.all_offers
    Paymill::Offer.all
  end

  def self.destroy_all_offers
    Paymill::Offer.all.each do |offer|
      Paymill::Offer.delete(offer.id)
    end

    Plan.all.each do |plan|
      plan.update_attribute(:paymill_id, nil)
    end
  end

  def self.create_all_offers
    Plan.all.each { |plan| plan.create_offer }
  end

  def self.destroy_all_clients
    Paymill::Client.all.each do |client|
      Paymill::Client.delete client.id
    end
    
  end

  # accessors

  def name
    self.plan_type.name
  end
end
