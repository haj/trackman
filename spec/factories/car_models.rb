# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car_model do
    name "MyString"
    car_manufacturer_id 1
  end
end
