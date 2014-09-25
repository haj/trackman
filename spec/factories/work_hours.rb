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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_hour do
    day_of_week 1
    starts_at DateTime.now.to_s(:db)
    ends_at DateTime.now.to_s(:db)
    work_schedule_id 1
  end
end
