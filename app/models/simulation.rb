class Simulation

	def self.movement(car_id)
		car = Car.find(car_id)
		device = car.device
		traccar_device = device.traccar_device

  		if traccar_device.last_position.nil?	
        	new_position = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 0.0, time: Time.zone.now, valid: true, device_id: device.id)
        	traccar_device.positions << new_position
  		end 

		old_position = traccar_device.last_position
		new_latitude = old_position[:latitude] + 0.001
		new_longitude = old_position[:longitude] + 0.001
		new_position = Traccar::Position.create(latitude: new_latitude, longitude: new_longitude, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 0.0, time: Time.zone.now, valid: true, device_id: device.id)
		traccar_device.positions << new_position
	end

	def self.speeding
		car = Car.find(car_id)
		device = car.device
		traccar_device = device.traccar_device
		new_position = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 70.0, time: Time.zone.now, valid: true, device_id: device.id)
       	traccar_device.positions << new_position
	end

	def self.outside_work_hours
		car = Car.find(car_id)
		device = car.device
		traccar_device = device.traccar_device
		new_position = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 70.0, time: Time.zone.now, valid: true, device_id: device.id)
       	traccar_device.positions << new_position
	end

	def self.long_pause

	end

	def self.long_driving

	end

	def self.enter_area

	end

	def self.left_area

	end



end