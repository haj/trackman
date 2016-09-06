class Notification < ActiveRecord::Base
	# Relationship
  belongs_to :user
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :notificationable, polymorphic: true

  # Scope
  scope :unread, -> { where(is_read: false) }
  scope :read, -> { where(is_read: true) }
end
