# == Schema Information
#
# Table name: parameters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  data_type  :string(255)
#  rule_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :parameter do
    name "MyString"
    type ""
    rule_id 1
  end
end
