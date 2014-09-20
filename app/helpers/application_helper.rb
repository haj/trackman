module ApplicationHelper

	def notifications_count(user)
		notifications = user.try(:company).try(:alarm_notifications).where(archived: false).try(:count)
		if notifications.nil?
			return 0 
		else
			return notifications
		end
	end

	def notification_title(notification)
		notification.subject.split(":")[0].strip
	end

	def notification_desc(notification)
		notification.subject.split(":")[1].strip
	end

	def gravatar(current_user)
		gravatar_image_url(current_user.email.gsub('spam', 'mdeering'))
	end

end
