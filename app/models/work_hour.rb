# == Schema Information
#
# Table name: work_hours
#
#  id          :integer          not null, primary key
#  day_of_week :integer
#  starts_at   :time
#  ends_at     :time
#  car_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class WorkHour < ActiveRecord::Base
	belongs_to :car
	
	serialize :starts_at, Tod::TimeOfDay
	serialize :ends_at, Tod::TimeOfDay
end
