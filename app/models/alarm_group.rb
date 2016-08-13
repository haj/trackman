# == Schema Information
#
# Table name: alarms_groups
#
#  id         :integer          not null, primary key
#  group_id   :integer          not null
#  alarm_id   :integer          not null
#  status     :string(255)
#  last_alert :datetime
#

class AlarmGroup < ActiveRecord::Base
  self.table_name = "alarms_groups"
    
  # ASSOCIATION GOES HERE
  belongs_to :groups
  belongs_to :alarms

  # VALIDATION GOES HERE
  validates :group_id, :alarm_id, presence: true
end
