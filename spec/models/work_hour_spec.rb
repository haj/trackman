# == Schema Information
#
# Table name: work_hours
#
#  id               :integer          not null, primary key
#  day_of_week      :integer
#  starts_at        :time
#  ends_at          :time
#  created_at       :datetime
#  updated_at       :datetime
#  work_schedule_id :integer
#

require 'spec_helper'

describe WorkHour do
  pending "add some examples to (or delete) #{__FILE__}"
end
