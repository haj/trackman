# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device_model do
    name "MyString"
    device_manufacturer_id 1
    protocol "MyString"
  end
end
