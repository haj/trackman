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
	has_many :states
	has_many :work_hours
	belongs_to :group
	has_and_belongs_to_many :alarms
	has_many :alarm_cars

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
		def alarm_status(alarm)
			self.car_alarms.where(alarm_id: rule.id, car_id: self.id).first.status
		end

		# fetch last_alert time of the rule associated with this car
		def alarm_last_alert(alarm)
			self.car_alarms.where(alarm_id: rule.id, car_id: self.id).first.last_alert
		end

	# ALARMS


	def check_alarms
		self.alarms.all.each do |alarm|
			puts alarm.verify(self.id)
			# if result == true
			# 	#send email to user with name of the alarm triggered
			# end
		end
	end


	def moving?
		if self.no_data?
			return false
		else
			return self.device.moving?
		end
	end

	def no_data?
		# check if last time a new position reported is longer than x minutes
		return !self.has_device? || self.device.no_data?
	end








end
