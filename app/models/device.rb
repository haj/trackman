class Device < ActiveRecord::Base

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

	# check if the car (through the device) is moving or not
	def update_movement_status
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

	# check if the car is moving during work hours
	def check_if_during_work_hours
		# get this device working hours
		# check if current time is inside the working hours schedule
		# return true if it's working hours 
		# return false if car used outside working hours
	end

	
	
end
