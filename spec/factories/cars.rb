# == Schema Information
#
# Table name: cars
#
#  id              :integer          not null, primary key
#  mileage         :float
#  numberplate     :string(255)
#  car_model_id    :integer
#  car_type_id     :integer
#  registration_no :string(255)
#  year            :integer
#  color           :string(255)
#  group_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#  company_id      :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car do
    mileage 1.5
    numberplate "MyString"
    car_model_id 1
    car_type_id 1
    registration_no "MyString"
    year 1
    color "MyString"
    group_id 1
  end
end
