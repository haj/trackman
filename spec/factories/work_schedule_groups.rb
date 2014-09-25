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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_schedule_group do
    company_id 1
    work_schedule_id 1
    name "WorkScheduleGroup"
  end
end
