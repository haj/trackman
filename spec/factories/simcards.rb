# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :simcard do
    telephone_number "MyString"
    teleprovider_id 1
    monthly_price 1.5
    device_id 1
  end
end
