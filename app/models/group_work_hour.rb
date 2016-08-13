# == Schema Information
#
# Table name: group_work_hours
#
#  id          :integer          not null, primary key
#  day_of_week :integer
#  starts_at   :datetime
#  ends_at     :datetime
#  group_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class GroupWorkHour < ActiveRecord::Base
  # ASSOCIATION
  belongs_to :group

  # SERIALIZE
  serialize :starts_at, Tod::TimeOfDay
  serialize :ends_at, Tod::TimeOfDay

  # validation
  validates :group_id, presence: true

end
