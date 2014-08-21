# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :position do
    address "MyString"
    altitude 1.5
    course 1.5
    latitude 1.5
    longitude 1.5
    other "MyString"
    power 1.5
    speed 1.5
    device_id 1
  end
end
