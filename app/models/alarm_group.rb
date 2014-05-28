class AlarmGroup < ActiveRecord::Base
	self.table_name = "alarms_groups"
	
	belongs_to :groups
	belongs_to :alarms
end
