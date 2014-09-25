# == Schema Information
#
# Table name: car_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CarType < ActiveRecord::Base
	has_many :cars

	validates :name, presence: true
end
