module UsersHelper
	def all_roles
		return Role.all.collect {|a| [ a.name, a.name ] }
	end
end
