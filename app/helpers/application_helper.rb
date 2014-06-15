module ApplicationHelper
	def notifications_count(user)
		user.mailbox.notifications.count
	end
end
