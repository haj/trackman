# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :work_hour do
    day_of_week 1
    starts_at "2014-05-20 18:11:04"
    ends_at "2014-05-20 18:11:04"
    device_id 1
  end
end
