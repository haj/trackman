module GroupsHelper
	def all_groups
		Group.all.collect {|a| [ a.name, a.id ] }
	end
end
