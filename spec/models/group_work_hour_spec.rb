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

require 'spec_helper'

describe GroupWorkHour do
  pending "add some examples to (or delete) #{__FILE__}"
end
