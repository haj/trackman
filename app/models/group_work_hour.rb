class GroupWorkHour < ActiveRecord::Base
	belongs_to :group

	serialize :starts_at, Tod::TimeOfDay
	serialize :ends_at, Tod::TimeOfDay
end
