# == Schema Information
#
# Table name: payments
#
#  id         :integer          not null, primary key
#  company_id :integer
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    company_id 1
  end
end
