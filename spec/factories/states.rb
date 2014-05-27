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
