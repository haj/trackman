# == Schema Information
#
# Table name: car_models
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  car_manufacturer_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :car_model do
    name "MyString"
    car_manufacturer_id 1
  end
end
