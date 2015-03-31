# This will pick the first device in the Traccar db and generate few positions 
# to make the car look like it's been moving
task :move, [:message]  => :environment  do |t, args|
  
  device = Device.where(emei: args.message).first

  puts device.to_json 
	
  traccar_device = device.traccar_device

  traccar_device.positions.destroy_all

  if traccar_device.last_position.nil? #device never moved 
    new_position = Traccar::Position.create(altitude: 0.0, 
      course: 0.0, 
      latitude: 48.85837, 
      longitude: 2.294481, 
      other: "<info><protocol>t55</protocol><battery>24</battery...", 
      power: nil, 
      speed: 0.0, 
      time: Time.now, 
      valid: true, 
      device_id: device.id)
    traccar_device.positions << new_position
  end 

  # Generate 20 positions

  20.times do |index|
    puts "Simulating position"
    old_position = traccar_device.last_position
    new_latitude = old_position[:latitude] + 0.001
    new_longitude = old_position[:longitude] + 0.001
    new_position = Traccar::Position.create(course: 0.0, 
      latitude: new_latitude, 
      longitude: new_longitude, 
      other: "<info><protocol>t55</protocol><battery>24</battery...", 
      speed: 0.0, 
      time: Time.now + 20*index, 
      valid: true, 
      device_id: device.id)
    traccar_device.positions << new_position
  end


end
