class Simulation
  def initialize(car_id)
    @car            = Car.find(car_id)
    @device         = @car.device
    @traccar_device = @device.traccar_device
  end

  def movement
    if @traccar_device.last_position.nil?  
      new_position = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 0.0, time: Time.zone.now, valid: true, device_id: @device.id)
      traccar_device.positions << new_position
    end 

    old_position  = traccar_device.last_position
    new_latitude  = old_position[:latitude] + 0.001
    new_longitude = old_position[:longitude] + 0.001
    new_position  = Traccar::Position.create(latitude: new_latitude, longitude: new_longitude, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 0.0, time: Time.zone.now, valid: true, device_id: @device.id)

    @traccar_device.positions << new_position
  end

  def speeding
    new_position   = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 70.0, time: Time.zone.now, valid: true, device_id: @device.id)

    @traccar_device.positions << new_position
  end

  def outside_work_hours
    new_position   = Traccar::Position.create(latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", speed: 70.0, time: Time.zone.now, valid: true, device_id: @device.id)
    
    @traccar_device.positions << new_position
  end

  def long_pause
    State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
    State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 23.minutes.ago)
    State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 7.minutes.ago)
    State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
  end

  def long_driving
    State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
    State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 23.minutes.ago)
    State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 7.minutes.ago)
    State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
  end
end