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
				new_work_hour = WorkHour.create(day_of_week: wh.day_of_week, starts_at: wh.starts_at, ends_at: wh.ends_at , work_schedule_id: work_schedule.id)
				work_schedule.work_hours << new_work_hour
			end 

			return work_schedule
		else
			return false
		end
		 
	end
end