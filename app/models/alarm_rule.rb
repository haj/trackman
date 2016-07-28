# == Schema Information
#
# Table name: alarms_rules
#
#  id          :integer          not null, primary key
#  rule_id     :integer          not null
#  alarm_id    :integer          not null
#  conjunction :string(255)
#  params      :text
#  deleted_at  :datetime
#

class AlarmRule < ActiveRecord::Base
  self.table_name = "alarms_rules"

  # INIT FROM GEM GOES HERE
  acts_as_paranoid

  # ASSOCIATION GOES HERE
  belongs_to :rule
  belongs_to :alarms

  # SERIALIZE GOES HERE
  serialize :params

end
