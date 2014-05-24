class GroupRule < ActiveRecord::Base
	self.table_name = "groups_rules"
	
	belongs_to :groups
	belongs_to :rules
end
