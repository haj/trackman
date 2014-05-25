class Rule < ActiveRecord::Base

	has_many :group_rules
	has_many :car_rules
	has_and_belongs_to_many :groups
	has_and_belongs_to_many :cars
	has_and_belongs_to_many :conditions

end
