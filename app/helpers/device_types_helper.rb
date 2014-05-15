module DeviceTypesHelper
	def all_device_types
		return DeviceType.all.collect {|a| [ a.name, a.id ] }
	end
end
