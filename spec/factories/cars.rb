# == Schema Information
#
# Table name: cars
#
#  id               :integer          not null, primary key
#  mileage          :float(24)
#  numberplate      :string(255)
#  car_model_id     :integer
#  car_type_id      :integer
#  registration_no  :string(255)
#  year             :integer
#  color            :string(255)
#  group_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  company_id       :integer
#  work_schedule_id :integer
#  name             :string(255)
#  deleted_at       :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car do
    name "Vehicle"
    mileage 1.5
    numberplate "44444"
    car_model_id 1
    car_type_id 1
    registration_no "44444"
    year 2014
    color "Red"
    group_id 1
  end
end
