class CarModel < ActiveRecord::Base
	belongs_to :car_manufacturer
	has_many :cars

	scope :by_car_manufacturer, -> car_manufacturer_id { where(:car_manufacturer_id => car_manufacturer_id) }

end
