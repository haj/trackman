module ApplicationHelper
	def notifications_count(user)
		user.mailbox.notifications.count
	end

	def notification_title(notification)
		notification.subject.split(":")[0].strip
	end

	def notification_desc(notification)
		notification.subject.split(":")[1].strip
	end

end
