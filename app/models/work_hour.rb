class WorkHour < ActiveRecord::Base
	belongs_to :car
	
	serialize :starts_at, Tod::TimeOfDay
	serialize :ends_at, Tod::TimeOfDay
end
