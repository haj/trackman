# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  altitude   :float
#  course     :float
#  latitude   :float
#  longitude  :float
#  other      :string(255)
#  power      :float
#  speed      :float
#  time       :datetime
#  valid      :boolean
#  device_id  :integer
#  created_at :timestamp        not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :position do
    address "MyString"
    altitude 1.5
    course 1.5
    latitude 1.5
    longitude 1.5
    other "MyString"
    power 1.5
    speed 1.5
    device_id 1
  end
end
