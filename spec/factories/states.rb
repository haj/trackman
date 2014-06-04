# == Schema Information
#
# Table name: states
#
#  id               :integer          not null, primary key
#  data             :boolean          default(FALSE)
#  movement         :boolean          default(FALSE)
#  authorized_hours :boolean          default(FALSE)
#  speed_limit      :boolean          default(FALSE)
#  long_hours       :boolean          default(FALSE)
#  long_pause       :boolean          default(FALSE)
#  car_id           :integer
#  created_at       :datetime
#  updated_at       :datetime
#  speed            :float            default(0.0)
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
