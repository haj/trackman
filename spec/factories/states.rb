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
#  speed      :float            default(0.0)
#  driver_id  :integer
#  device_id  :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state do
    data false
    movement false
    authorized_hours false
    speed_limit false
    long_hours false
    long_pause false
    car_id 1
  end
end
