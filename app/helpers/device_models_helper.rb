module DeviceModelsHelper
	def all_device_models
		return DeviceModel.all.collect {|a| [ a.name, a.id ] }
	end
end
