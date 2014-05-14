class DeviceModel < ActiveRecord::Base
	has_many :devices
	belongs_to :device_manufacturer

	scope :by_device_manufacturer, -> device_manufacturer_id { where(:device_manufacturer_id => device_manufacturer_id) }
end
