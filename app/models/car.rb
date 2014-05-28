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
	belongs_to :group

	after_save :apply_group_work_hours
	after_create :generate_default_work_hours

	# TODO : test it
	def apply_group_work_hours(record)
		# car inherits group work hours if 
		# 	car belongs to group and doesn't have work hours already defined
		if record.has_group? && record.work_hours.count == 0
			record.group.group_work_hours.each do |work_hour|
				new_work_shift = WorkHour.create(day_of_week: work_hour.day_of_week, starts_at: work_hour.starts_at, ends_at: work_hour.ends_at)
				record.work_hours << new_work_shift
			end
		end
	end

	# TODO : test it
	def generate_default_work_hours(record)
		if record.group.nil?
			(1..7).each do |day_of_week|
				starts_at = TimeOfDay.new 7 
				ends_at = TimeOfDay.parse "7pm" 
				new_work_shift = WorkHour.create(day_of_week: day_of_week, starts_at: starts_at, ends_at: ends_at) 
				record.work_hours << new_work_shift
			end
		end
	end

	def speed_limit
		return 60
	end

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

	# Positions
		
		def self.all_positions(cars)
			positions = Array.new
			cars.each do |car|
	      		if car.last_position.count != 0 
	        		positions << car.last_position
	      		end
	    	end
	    	return positions
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

	# Car.has_?

		def has_device?
			return !self.device.nil?
		end

		def has_driver?
			return !self.driver.nil?
		end

		def has_group?
			return !self.group.nil?
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

			current_state = State.new
			current_state.car_id = self.id

			if self.no_data? 
				# check if car has device associated with it 
				# 	and the device is not broken
				current_state.data = false

			elsif self.moving? 
				# check if car is operating during work hours 
				current_state.authorized_hours = self.movement_authorized?
				# check if driver is respecting speed limit
				current_state.speed_limit = self.speed_limit?
				# check if driver been driving for long hours
				current_state.long_hours = self.long_hours?
			else 
				# check if driver of this car took a long pause
				current_state.long_pause = self.long_pause?
			end

			# save current state of this car
			current_state.save!

			# compare the current state with the previous state and generate 
			# 	the notification to send to the manager
			previous_state = self.states.order("created_at DESC").limit(2).last

			updates = Array.new #things about this car that changed since last time we checked

			things_we_wanna_track = [:data, :movement, :authorized_hours, :speed_limit, :long_hours, :long_pause]

			things_we_wanna_track.each do |aspect| 
				if current_state.send(aspect) != previous_state.send(aspect)
					updates.append({ aspect => current_state.send(aspect) })
				end
			end

			return updates

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
			return !self.has_device? || self.device.no_data?
		end

		def speed_limit? 
			# check current speed and if it's respecting the speed limit for this vehicle
			# 	get the current speed from device

			if self.device.speed <= self.speed_limit # in km/h
				return true
			else
				return false
			end		
			
		end

		def stolen?
			# check if the engine off (but the car is still moving)
			# TODO : implement it

			return false
		end

		def long_hours?
			# check when was the last pause 
			# 	(let's say a pause is 15 minutes for now)
			# TODO : implement it

			return true
		end

		def long_pause? 
			# check when was the last the vehicle was moving 
			# 	(that way we can deduce the duration of the current pause and decide if it's too long or not)
			# TODO : implement it

			return false
		end


end
