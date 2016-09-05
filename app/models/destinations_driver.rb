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

  # Validation
  validates :user_id, presence: true
end
