class Car < ActiveRecord::Base

	scope :by_car_model, -> car_model_id { where(:car_model_id => car_model_id) }
	scope :by_car_type, -> car_type_id { where(:car_type_id => car_type_id) }
	scope :traceable, -> { where("id IN (SELECT car_id FROM Devices WHERE car_id NOT NULL)") }
	scope :untraceable, -> { where("id NOT IN (SELECT car_id FROM Devices WHERE car_id NOT NULL)") }
	scope :with_driver, -> { where("id IN (SELECT car_id FROM Users WHERE car_id NOT NULL)") }
	scope :without_driver, -> { where("id NOT IN (SELECT car_id FROM Users WHERE car_id NOT NULL)") }

	acts_as_tenant(:company)

	belongs_to :company
	belongs_to :car_model
	belongs_to :car_type
	has_one :device
	has_one :driver, :class_name => "User", :foreign_key => "car_id"

	def name
		if self.id.nil?
			return "Car"
		else
			return "##{id} - #{self.car_model.name} - #{self.car_type.name}"
		end
	end

	def self.cars_without_devices(car_id)
		if car_id.nil?
			Car.where("id NOT IN (SELECT car_id FROM Devices WHERE car_id NOT NULL)")
		else
			Car.where("id NOT IN (SELECT car_id FROM Devices WHERE car_id NOT NULL AND car_id != #{car_id})")
		end
	end

	def self.cars_without_drivers(car_id)
		if car_id.nil?
			Car.where("id NOT IN (SELECT car_id FROM Users WHERE car_id NOT NULL)")
		else
			Car.where("id NOT IN (SELECT car_id FROM Users WHERE car_id NOT NULL AND car_id != #{car_id})")
		end
	end

	def self.all_positions(cars)
		positions = Array.new
		cars.each do |car|
      		if !car.last_position.empty? 
        		positions << car.last_position
      		end
    	end
    	return positions
	end

	def has_device?
		return !self.device.nil?
	end

	def has_driver?
	end

	def last_position
		if self.device.nil?
			return Hash.new
		else
			self.device.last_position
		end
	end

end
