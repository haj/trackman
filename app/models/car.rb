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
	has_and_belongs_to_many :rules
	has_many :car_rules

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

	# Generate the pos
	def self.all_positions(cars)
		positions = Array.new
		cars.each do |car|
      		if car.last_position.count != 0 
        		positions << car.last_position
      		end
    	end
    	return positions
	end

	def has_device?
		return !self.device.nil?
	end

	def has_driver?
		return !self.driver.nil?
	end

	# Generate a hash with latitude and longitude of the car (fetched through the device GPS data)
	#   Also for this hash to be non-empty, the car must have a device associated with it in the database
	def last_position
		if self.device.nil?
			# if this car doesn't have a device attached to it 
			#   then just send an empty hash for the position
			return Hash.new
		else
			self.device.last_position
		end
	end

	def moving?
		return self.device.movement
	end

	# ALARMS

	# check if car is moving or idle
	def update_movement_status
		if self.has_device? 
			return self.device.update_movement_status
		else 
			return "Car doesn't have device"
		end
	end

	# Check if car is authorized to be moving 
	#  (means if the driver is using the vehicle during his work hours or not)
	def movement_authorized?
		if car.has_device? 
			return car.device.movement_authorized?
		else
			# This return false but in reality if means this car doesn't have a device associated with it in the database
			# TODO : change this to something more meaningful
			return false
		end
	end

	# RULES

	# fetch name of the rule associated with this car
	def rule_status(rule)
		self.car_rules.where(rule_id: rule.id, car_id: self.id).first.status
	end

	# fetch last_alert time of the rule associated with this car
	def rule_last_alert(rule)
		self.car_rules.where(rule_id: rule.id, car_id: self.id).first.last_alert
	end


end
