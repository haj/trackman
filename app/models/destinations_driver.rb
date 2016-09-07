class DestinationsDriver < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :pending, :initial => true
    state :accepted, :declined

    after_all_transitions [:read_notification, :notif_admin]

    event :accept do
      transitions :from => :pending, :to => :accepted
    end    

    event :decline do
      transitions :from => :pending, :to => :declined
    end    
  end

  # ASSOCIATION
  belongs_to :user
  belongs_to :order
  has_one :notification, as: :notificationable, dependent: :destroy
  has_one :declined_order, dependent: :nullify
  has_many :accepted_destinations, dependent: :nullify

  # Validation
  validates :user_id, presence: true

  # Callback
  after_create :create_notification

  def create_notification
    self.build_notification(user_id: user_id, action: 'assigned', sender_id: order.xml_destination.user_id)
    self.save!
  end

  def notif_admin
    User.by_role(:manager).each do |u|
      self.build_notification(user_id: u.id, sender_id: user_id, action: aasm.to_state)
    end
  end

  def read_notification
    self.notification.update(is_read: true) unless notification.is_read
  end
end
