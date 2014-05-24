class CarRule < ActiveRecord::Base
	self.table_name = "cars_rules"
	belongs_to :cars
	belongs_to :rules
end
