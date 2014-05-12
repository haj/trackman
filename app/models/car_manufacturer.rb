class CarManufacturer < ActiveRecord::Base

	has_many :car_models
	
end
