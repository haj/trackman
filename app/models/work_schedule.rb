# == Schema Information
#
# Table name: work_schedules
#
#  id         :integer          not null, primary key
#  car_id     :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class WorkSchedule < ActiveRecord::Base
	has_many :cars
	has_many :work_hours

	def create_clone
		work_schedule = WorkSchedule.new
		work_schedule.name = self.name
		
		if work_schedule.save
			self.work_hours.each do |wh|
				WorkHour.create(day_of_week: wh.day_of_week, starts_at: wh.starts_at.to_s.to_time.in_time_zone.to_datetime.to_s(:db), ends_at: wh.ends_at.to_s.to_time.in_time_zone.to_datetime.to_s(:db) , work_schedule_id: work_schedule.id)
			end 

			return work_schedule
		else
			return false
		end
		 
	end
end
