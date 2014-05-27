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
	has_many :states
	has_many :work_hours

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

	

	# RULES

	# fetch name of the rule associated with this car
	def rule_status(rule)
		self.car_rules.where(rule_id: rule.id, car_id: self.id).first.status
	end

	# fetch last_alert time of the rule associated with this car
	def rule_last_alert(rule)
		self.car_rules.where(rule_id: rule.id, car_id: self.id).first.last_alert
	end

	# ALARMS
	
	def generate_alarms

		state = State.new

		if self.no_data? 
			# check if car has device associated with it 
			state.data = false

		elsif self.moving? 
			state.authorized_hours = self.movement_authorized?
			state.speed_limit = self.speed_limit?
			state.long_hours = self.long_hours?
		else 

			state.long_pause = self.long_pause?
		end

		state.save!

	end

	def moving?
		if self.has_device? 
			return self.device.update_movement_status
		else 
			return "Car doesn't have device"
		end
	end

	# check if the car is moving during work hours
	def movement_authorized?
		time_now = Time.now
		current_time = time_now.to_time_of_day
		current_day_of_week = time_now.wday

		self.work_hours.each do |work_hour|
			shift = Shift.new(work_hour.starts_at, work_hour.ends_at)
			if shift.include?(current_time) && work_hour.day_of_week == current_day_of_week
				return true
			end
		end

		return false
	end

	def no_data?
		# check if last time a new position reported is longer than x minutes
		return !car.has_device? || car.device.no_data?
	end

	def speed_limit? 
		
		# check current speed and if it's respecting the speed limit for this vehicle
		# get the current speed from device
		# TODO 
	end

	def stolen?
		# check if the engine off (but the car is still moving)
		# TODO
	end

	def long_hours?
		# check when was the last pause 
		# 	(let's say a pause is 15 minutes for now)
		# TODO
	end

	def long_pause? 
		# check when was the last the vehicle was moving 
		# 	(that way we can deduce the duration of the current pause and decide if it's too long or not)
		# TODO
	end


end
