# == Schema Information
#
# Table name: device_manufacturers
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class DeviceManufacturer < ActiveRecord::Base
	has_many :device_models
end
