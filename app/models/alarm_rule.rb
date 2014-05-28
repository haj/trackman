class AlarmRule < ActiveRecord::Base
	self.table_name = "alarms_rules"
	
	belongs_to :rules
	belongs_to :alarms
end
