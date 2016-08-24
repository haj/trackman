# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  no_data    :boolean          default(FALSE)
#  moving     :boolean          default(FALSE)
#  car_id     :integer
#  created_at :datetime
#  updated_at :datetime
#  speed      :float(24)        default(0.0)
#  driver_id  :integer
#  device_id  :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do
    no_data false
    moving false
    car_id 1
    speed 60
    driver_id 1
    device_id 1
  end
end
