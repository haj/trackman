class AlarmCar < ActiveRecord::Base
	self.table_name = "alarms_cars"
	
	belongs_to :cars
	belongs_to :alarms
end
