# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  name       :string(255)
#  paymill_id :string(255)
#  created_at :datetime
#  updated_at :datetime
#  plan_id    :integer
#  company_id :integer
#  active     :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    email "MyString"
    name "MyString"
    paymill_id "MyString"
  end
end
