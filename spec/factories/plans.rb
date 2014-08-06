# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :plan do
    plan_type_id 1
    interval "MyString"
    currency "MyString"
    price 1.5
    paymill_id "MyString"
  end
end
