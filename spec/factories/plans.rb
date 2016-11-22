# == Schema Information
#
# Table name: plans
#
#  id           :integer          not null, primary key
#  plan_type_id :integer
#  interval     :string(255)
#  currency     :string(255)
#  price        :float(24)
#  paymill_id   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

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
