module GroupsHelper
	def all_groups
		return Group.all.collect {|a| [ a.name, a.id ] }
	end
end
