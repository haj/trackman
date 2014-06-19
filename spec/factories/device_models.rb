# == Schema Information
#
# Table name: device_models
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  device_manufacturer_id :integer
#  protocol               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :device_model do
    name "MyString"
    device_manufacturer_id 1
    protocol "MyString"
  end
end
