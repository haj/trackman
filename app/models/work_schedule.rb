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
end
