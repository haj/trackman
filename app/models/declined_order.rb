class DeclinedOrder < ActiveRecord::Base
  # Relationship
  belongs_to :destinations_driver

  # Callback
  after_create :change_state_destination

  # Attr accessor
  attr_accessor :notif_id, :status

  # Method
  def change_state_destination
    self.status == 'decline' ? destinations_driver.decline : destinations_driver.cancel
    destinations_driver.save
  end
end
