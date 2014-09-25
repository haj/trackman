# == Schema Information
#
# Table name: features
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Feature < ActiveRecord::Base
	has_and_belongs_to_many :plan_types
end
