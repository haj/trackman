# == Schema Information
#
# Table name: rule_notifications
#
#  id         :integer          not null, primary key
#  rule_id    :integer
#  car_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class RuleNotification < ActiveRecord::Base
	
end
