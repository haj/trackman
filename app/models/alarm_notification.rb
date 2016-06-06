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
	# INIT GEM GOES HERE
  include PublicActivity::Common
	acts_as_tenant(:company)

	# ASSOCIATION GOES HERE
	belongs_to :alarm
	belongs_to :car 
end
