# == Schema Information
#
# Table name: vertices
#
#  id         :integer          not null, primary key
#  latitude   :float(24)
#  longitude  :float(24)
#  region_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vertex do
    latitude 1.5
    longitude 1.5
    region_id 1
  end
end
