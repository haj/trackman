class AcceptedDestination < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :on_road, :initial => true
    state :deliver, :decline

    event :delivered do
      transitions :from => :on_road, :to => :deliver
    end    
  end

  # Relationship
  belongs_to :destinations_driver
  belongs_to :first_location, :class_name => "Location"
  belongs_to :last_location, :class_name => "Location"
end
