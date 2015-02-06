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

require 'spec_helper'

describe AlarmNotification do
  skip "add some examples to (or delete) #{__FILE__}"
end
