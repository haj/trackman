namespace :simulate do
  task :moving_cars => :environment do
  	Traccar::Device.all.each do |device|
  		if device.last_position.count == 0
  			# generate the first position for this device
        new_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
        device.positions << new_position
  		else 			
        # generate a new position based on the old position 
        old_position = device.last_position
        #puts "#{device.id} #{old_position}"
        new_latitude = old_position[:latitude] + 0.001
        new_longitude = old_position[:longitude] + 0.001
        new_position = Traccar::Position.create(course: 0.0, latitude: new_latitude, longitude: new_longitude, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
        device.positions << new_position
  		end
  	end
  end
end