# == Schema Information
#
# Table name: work_schedules
#
#  id         :integer          not null, primary key
#  car_id     :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_schedule do
    car_id 1
    name "MyString"
  end
end
