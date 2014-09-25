# == Schema Information
#
# Table name: alarm_notifications
#
#  id         :integer          not null, primary key
#  car_id     :integer
#  driver_id  :integer
#  alarm_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  archived   :boolean          default(FALSE)
#

class AlarmNotification < ActiveRecord::Base
	belongs_to :alarm
	belongs_to :car 

	acts_as_tenant(:company)
end
