# == Schema Information
#
# Table name: work_schedule_groups
#
#  id               :integer          not null, primary key
#  company_id       :integer
#  work_schedule_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  name             :string(255)
#

require 'spec_helper'

describe WorkScheduleGroup do
  skip "add some examples to (or delete) #{__FILE__}"
end
