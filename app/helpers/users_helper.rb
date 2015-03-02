module UsersHelper

	def all_roles
		return Role.all.collect {|a| [ a.name.capitalize, a.name ] }
	end

	def conversations_count(user)
		user.mailbox.inbox(read: false).to_a.count
	end

	def days_ago_in_words(from_date, to_date, options={})
	  delta = (from_date - Date.parse(to_date.to_s)).to_i
	  if delta == 0 
	  	return "Today"
	  elsif delta == 1
	  	return "Yesterday"
	  else
	  	return "#{delta} days ago"
	  end
	end

	def first_user?()
	end

end
