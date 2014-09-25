# == Schema Information
#
# Table name: rule_notifications
#
#  id         :integer          not null, primary key
#  rule_id    :integer
#  car_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rule_notification do
    rule_id 1
    car_id 1
  end
end
