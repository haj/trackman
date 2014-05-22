namespace :simulate do
  task :moving_cars => :environment do
  	Traccar::Device.each do |device|
  		if !device.last_position.empty?
  			# generate a new position based on the old position 
  			old_position = device.last_position
  			new_latitude = old_position.latitude + 0.001
  			new_longitude = old_position.latitude + 0.001
  			new_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: new_latitude, longitude: new_longitude, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  			device.positions << new_position
  		else
  			# generate the first position for this device
  			new_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.85837, longitude: 2.294481, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  			device.positions << new_position
  		end
  	end
  	# Company.all.each do |company|
  	# 	puts "Company : #{company.name} => "
  	# 	company.cars.each do |car|
  	# 		puts car.update_movement_status
  	# 	end
  	# end
  end
end