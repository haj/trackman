# == Schema Information
#
# Table name: teleproviders
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  apn        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :teleprovider do
    name "MyString"
    apn "MyString"
  end
end
