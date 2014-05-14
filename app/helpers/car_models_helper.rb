module CarModelsHelper
	def all_car_models
		return CarModel.all.collect {|a| [ a.name, a.id ] }
	end
end
