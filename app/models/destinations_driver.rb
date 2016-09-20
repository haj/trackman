class DestinationsDriver < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :pending, :initial => true
    state :accepted, :canceled, :declined, :finished

    after_all_transitions [:read_notification, :notif_admin]

    event :accept, after: :order_accept do
      transitions :from => :pending, :to => :accepted
    end    

    event :cancel, after: :order_cancel  do
      transitions :from => :accepted, :to => :canceled
    end

    event :decline, after: :order_decline do
      transitions :from => :pending, :to => :declined
    end    

    event :finish, after: :order_finish do
      transitions :from => :accepted, :to => :finished
    end
  end

  # ASSOCIATION
  belongs_to :user
  belongs_to :order
  has_many :notifications, as: :notificationable, dependent: :destroy
  has_one :declined_order, dependent: :nullify
  has_many :accepted_destinations, dependent: :nullify

  # Validation
  validates :user_id, presence: true

  # Callback
  before_create :delete_last_pending
  after_create :create_notification, :set_order_state

  def delete_last_pending
    if order.pending?
      last_destination = order.destinations_drivers.last

      last_destination.destroy if last_destination && last_destination.pending?
    end
  end

  def set_order_state
    order.pend
    order.save!
  end

  def create_notification
    self.notifications.create(user_id: user_id, action: 'assigned', sender_id: order.xml_destination.user_id)
    self.save!
  end

  def notif_admin
    User.by_role(:manager).each do |u|
      self.notifications.create(user_id: u.id, sender_id: user_id, action: aasm.to_state)
    end
  end

  def read_notification
    notif = notifications.find_by(user_id: user_id)
    notif.update(is_read: true) unless notif.is_read
  end

  def order_accept
    order.accept
    order.save!
  end

  def order_decline
    order.decline
    order.save!
  end

  def order_finish
    order.finish
    order.save!    
  end

  def order_cancel
    order.cancel
    order.save!        
  end
end
