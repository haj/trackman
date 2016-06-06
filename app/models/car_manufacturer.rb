# == Schema Information
#
# Table name: car_manufacturers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class CarManufacturer < ActiveRecord::Base
	# ASSOCIATION
	has_many :car_models

	# VALIDATION
	validates :name, presence: true
end
