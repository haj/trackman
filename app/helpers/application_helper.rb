module ApplicationHelper
	def notifications_count(user)
		notifications = user.try(:company).try(:alarm_notifications).try(:count)
		if notifications.nil?
			return []
		end
	end

	def notification_title(notification)
		notification.subject.split(":")[0].strip
	end

	def notification_desc(notification)
		notification.subject.split(":")[1].strip
	end

end
