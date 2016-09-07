class Order < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :pending, :initial => true
    state :accepted, :declined, :finished

    event :pend do
    	transitions :from => [:pending, :declined], to: :pending
    end

    event :accept do
      transitions :from => :pending, :to => :accepted
    end    

    event :decline do
      transitions :from => :pending, :to => :declined
    end    

    event :finish do
      transitions :from => :accepted, :to => :finished
    end
  end

	# Relationship
  belongs_to :xml_destination
  has_many :destinations_drivers
  has_many :users, through: :destinations_drivers

  # Nested attr
  accepts_nested_attributes_for :destinations_drivers, allow_destroy: true, reject_if: :all_blank  

  def accepted_user
  	destinations_drivers.find_by(aasm_state: "accept")  	
  end
end
