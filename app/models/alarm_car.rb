# == Schema Information
#
# Table name: alarms_cars
#
#  id         :integer          not null, primary key
#  car_id     :integer          not null
#  alarm_id   :integer          not null
#  status     :string(255)
#  last_alert :datetime
#

class AlarmCar < ActiveRecord::Base
  self.table_name = "alarms_cars"

  # ASSOCIATION GOES HERE
  belongs_to :cars
  belongs_to :alarms
end
