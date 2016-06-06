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

  def self.speeding(car_id)
    car = Car.find(car_id)
    device = car.device
    traccar_device = device.traccar_device
    new_position = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 70.0, time: Time.zone.now, valid: true, device_id: device.id)
        traccar_device.positions << new_position
  end

  def self.outside_work_hours(car_id)
    car = Car.find(car_id)
    device = car.device
    traccar_device = device.traccar_device
    new_position = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 70.0, time: Time.zone.now, valid: true, device_id: device.id)
        traccar_device.positions << new_position
  end

  def self.long_pause(car_id)
    car = Car.find(car_id)
    # this would simulate a car that stopped for 16 minutes in the last 30 minutes
    State.create(no_data: false, moving: true, car_id: car.id, speed: 0.0, created_at: 30.minutes.ago)
    State.create(no_data: false, moving: false, car_id: car.id, speed: 0.0, created_at: 23.minutes.ago)
    State.create(no_data: false, moving: false, car_id: car.id, speed: 0.0, created_at: 7.minutes.ago)
    State.create(no_data: false, moving: true, car_id: car.id, speed: 0.0, created_at: 2.minutes.ago)
  end

  def self.long_driving(car_id)
    car = Car.find(car_id)
    # this would simulate a car that been driving for at least 16 consecutive minutes in the last half hour
    State.create(no_data: false, moving: false, car_id: car.id, speed: 0.0, created_at: 30.minutes.ago)
    State.create(no_data: false, moving: true, car_id: car.id, speed: 0.0, created_at: 23.minutes.ago)
    State.create(no_data: false, moving: true, car_id: car.id, speed: 0.0, created_at: 7.minutes.ago)
    State.create(no_data: false, moving: false, car_id: car.id, speed: 0.0, created_at: 2.minutes.ago)
  end

  def self.enter_area(car_id)

  end

  def self.left_area(car_id)

  end
  
end