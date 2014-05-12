class DeviceManufacturer < ActiveRecord::Base
	has_many :device_models
end
