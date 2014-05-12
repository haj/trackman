class CarModel < ActiveRecord::Base
	belongs_to :car_manufacturer
	has_many :cars
end
