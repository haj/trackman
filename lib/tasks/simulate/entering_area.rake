namespace :simulate do
  task :enter_area => :environment do
  	Traccar::Device.all.each do |device|
  		outside_region = Traccar::Position.create(altitude: 0.0, course: 0.0, 
  			latitude: 48.859494, 
  			longitude: 2.289813, 
  			other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << outside_region

  		eiffel_tower_region = { :latitude => 48.858370, :longitude => 2.294481 }

  		inside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, 
  			latitude: eiffel_tower_region[:latitude], 
  			longitude: eiffel_tower_region[:longitude], 
  			other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << inside_position

  	end
  end
end