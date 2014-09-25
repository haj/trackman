# == Schema Information
#
# Table name: alarm_notifications
#
#  id         :integer          not null, primary key
#  car_id     :integer
#  driver_id  :integer
#  alarm_id   :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  archived   :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :alarm_notification do
    car_id 1
    driver_id 1
    alarm_id 1
  end
end
