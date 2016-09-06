class DestinationsDriver < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :pending, :initial => true
    state :accepted, :declined

    event :accept, after: :read_notification do
      transitions :from => :pending, :to => :accepted
		end    

    event :decline, after: :read_notification do
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

  def read_notification
  	self.notification.update(is_read: true) unless notification.is_read
  end
end
