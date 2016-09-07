class DeclinedOrder < ActiveRecord::Base
  # Relationship
  belongs_to :destinations_driver

  # Callback
  after_create :change_state_destination

  # Attr accessor
  attr_accessor :notif_id

  # Method
  def change_state_destination
    destinations_driver.decline
    destinations_driver.save
  end
end
