class Group < ActiveRecord::Base
	has_many :cars
	acts_as_tenant(:company)

	has_and_belongs_to_many :alarms
	has_many :alarm_groups
	has_many :group_work_hours

	accepts_nested_attributes_for :alarms

	after_create :generate_default_work_hours

	def generate_default_work_hours
		(1..7).each do |day_of_week|
			starts_at = TimeOfDay.new 7 
			ends_at = TimeOfDay.parse "7pm" 
			new_work_shift = GroupWorkHour.create(day_of_week: day_of_week, starts_at: starts_at, ends_at: ends_at) 
			self.group_work_hours << new_work_shift
		end
	end

	def alarm_status(alarm)
		self.alarm_groups.where(alarm_id: alarm.id, group_id: self.id).first.status
	end

	def alarm_last_alert(alarm)
		self.alarm_groups.where(alarm_id: alarm.id, group_id: self.id).first.last_alert
	end
	
end
