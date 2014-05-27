class Device < ActiveRecord::Base
	include ActionView::Helpers::DateHelper

	scope :by_device_model, -> device_model_id { where(:device_model_id => device_model_id) }
	scope :by_device_type, -> device_type_id { where(:device_type_id => device_type_id) }

	scope :with_simcard, -> { where("id IN (SELECT device_id FROM Simcards WHERE device_id NOT NULL)") }
	scope :without_simcard, -> { where("id NOT IN (SELECT device_id FROM Simcards WHERE device_id NOT NULL)") }
	
	scope :available, -> { where(:car_id => nil) }
	scope :used, -> { where("car_id NOT NULL") }

	acts_as_tenant(:company)

	has_one :simcard
	belongs_to :device_model 
	belongs_to :device_type
	belongs_to :car
	belongs_to :company
	has_many :work_hours


	def self.available_devices
		Device.where(:car_id => nil)
	end

	def self.devices_without_simcards(device_id)
		if device_id.nil?
			Device.where("id NOT IN (SELECT device_id FROM Simcards WHERE device_id NOT NULL)")
		else
			Device.where("id NOT IN (SELECT device_id FROM Simcards WHERE device_id NOT NULL) OR id = #{device_id}")
		end
	end

	def has_car?
		!self.car_id.nil?
	end

	def has_simcard? 
		!self.simcard.nil?
	end

	def last_position
		device = Traccar::Device.where(uniqueId: self.emei).first
		if device.nil?
			return Hash.new
		else
			Traccar::Device.where(uniqueId: self.emei).first.last_position
		end
	end

	def last_positions(number=2)
		traccar_device = Traccar::Device.where(:uniqueId => self.emei).first
		return traccar_device.last_positions(number)
	end

	# check if the device is reporting that the car is moving (or not)
	def moving?
		last_positions = self.last_positions(2).to_a
		if last_positions.count == 2
			latitude1 = last_positions[0].latitude 
			longitude1 = last_positions[0].longitude
			latitude2 = last_positions[1].latitude
			longitude2 = last_positions[1].longitude

			threshold = 0.0001
			if (latitude1 - latitude2).abs < threshold && (longitude1 - longitude2).abs < threshold
				self.update_attributes(:movement => false, :last_checked => DateTime.now)
				return "Device[#{self.name}] isn't moving"
			else 
				self.update_attributes(:movement => true, :last_checked => DateTime.now)
				return "Device[#{self.name}] is moving"
			end 
		else
			return "Device[#{self.name}] doesn't have GPS data"
		end
	end

	def traccar_device
		Traccar::Device.where(uniqueId: self.emei).first
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
		last_position = self.traccar_device.positions.last

		seconds_since_last_position = Shift.new(Time.now.to_time_of_day, last_position.time.to_time_of_day).duration
		
		#return "#{time_ago_in_words(last_position.time)} ago OR #{since} seconds"
		
		if seconds_since_last_position >= ENV['no_data_threshold'].to_i.minutes
			return true
		else
			return false
		end
	end

	def speed
		self.traccar_device.positions.last.speed
	end

	def speed_limit? 
		# check current speed and if it's respecting the speed limit for this vehicle
		# get the current speed from device
	end

	def stolen?
		# check if the engine off (but the car is still moving)
	end

	def long_hours?
		# check when was the last pause 
		# 	(let's say a pause is 15 minutes for now)
	end

	def long_pause? 
		# check when was the last the vehicle was moving 
		# 	(that way we can deduce the duration of the current pause and decide if it's too long or not)
	end
	
	
end
