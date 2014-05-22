namespace :simulate do
  task :idle_cars => :environment do
  	Traccar::Device.each do |device|
  		if !device.last_position.empty?
  			old_position = device.last_position
  			latitude = old_position.latitude
  			longitude = old_position.latitude
  			position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: latitude, longitude: longitude, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		else
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