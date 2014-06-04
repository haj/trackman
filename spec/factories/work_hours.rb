# == Schema Information
#
# Table name: work_hours
#
#  id          :integer          not null, primary key
#  day_of_week :integer
#  starts_at   :time
#  ends_at     :time
#  car_id      :integer
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_hour do
    day_of_week 1
    starts_at "2014-05-20 18:11:04"
    ends_at "2014-05-20 18:11:04"
    device_id 1
  end
end
