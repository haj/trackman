module DeviceManufacturersHelper
	def all_device_manufacturers
		return DeviceManufacturer.all.collect {|a| [ a.name, a.id ] }
	end
end
