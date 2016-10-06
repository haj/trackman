class Order < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :pending, :initial => true
    state :accepted, :declined, :canceled, :finished

    event :pend do
    	transitions :from => [:pending, :declined, :canceled], to: :pending
    end

    event :accept do
      transitions :from => :pending, :to => :accepted
    end    

    event :decline do
      transitions :from => :pending, :to => :declined
    end    

    event :cancel do
      transitions :from => :accepted, :to => :canceled
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
    destinations_drivers.find_by(aasm_state: "accepted")    
  end

  def my_destination(current_user_id)
    destinations_drivers.find_by(user_id: current_user_id)
  end

  def my_notif_id(current_user_id)
    my_destination(current_user_id).notifications.find_by(user_id: current_user_id).try(:id)
  end

  class << self
    def all_available(filter = '')
      return joins(:xml_destination) if filter == 'All' || filter.blank?
      
      joins(:xml_destination).where(aasm_state: filter.downcase)      
    end

    def assigned_to(user_id, filter = '')
      return assigned_to_query(user_id) if filter == 'All' || filter.blank?

      assigned_to_query(user_id).where(aasm_state: filter.downcase)
    end

    def assigned_to_query(user_id)
      joins(:destinations_drivers).joins(:destinations_drivers => :notifications).
      where(destinations_drivers: { user_id: user_id }, notifications: { user_id: user_id }).
      select("orders.*, destinations_drivers.id AS destination_id, destinations_drivers.aasm_state AS des_state,
        notifications.id AS notif_id").
      order(id: :desc)
    end

    def assigned_home(user_id, filter = '')
      self.assigned_to_query(user_id).where('destinations_drivers.aasm_state in(?)', ['pending', 'accepted'])
    end
  end
end
