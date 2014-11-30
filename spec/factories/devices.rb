# == Schema Information
#
# Table name: devices
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  uniqueId          :string(255)
#  latestPosition_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :device do
  	name "factoryDevice"
    emei  "123456789"
    cost_price 1.5
    device_model_id 1
    device_type_id 1
    car_id 1
  end

end
