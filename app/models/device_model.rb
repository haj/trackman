class DeviceModel < ActiveRecord::Base
	has_many :devices
	belongs_to :device_manufacturer
end
