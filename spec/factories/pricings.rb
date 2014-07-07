# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :pricing do
    name "MyString"
    billable_days 1
    amount 1.5
    plan_id 1
  end
end
