module UsersHelper

	def all_roles
		return Role.all.collect {|a| [ a.name.capitalize, a.name ] }
	end

	def conversations_count(user)
		user.mailbox.conversations.to_a.count
	end

end
