# == Schema Information
#
# Table name: work_hours
#
#  id               :integer          not null, primary key
#  day_of_week      :integer
#  starts_at        :datetime
#  ends_at          :datetime
#  created_at       :datetime
#  updated_at       :datetime
#  work_schedule_id :integer
#  company_id       :integer
#  deleted_at       :datetime
#

require 'spec_helper'

describe WorkHour do
  skip "add some examples to (or delete) #{__FILE__}"
end
