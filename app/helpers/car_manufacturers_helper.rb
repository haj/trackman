module CarManufacturersHelper
	def all_car_manufacturers
		return CarManufacturer.all.collect {|a| [ a.name, a.id ] }
	end
end
