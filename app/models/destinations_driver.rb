class DestinationsDriver < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :pending, :initial => true
    state :accept, :decline

    event :accepted do
      transitions :from => :pending, :to => :accept
		end    

    event :declined do
      transitions :from => :pending, :to => :decline
		end    
  end

  # ASSOCIATION
  belongs_to :user
  belongs_to :order
  has_many :notifications, as: :notificationable, dependent: :destroy

  # Validation
  validates :user_id, presence: true

  # Callback
  after_create :create_notification

  def create_notification
  	self.notifications.create(user_id: user_id, action: 'assigned', sender_id: order.xml_destination.user_id)
  end
end
