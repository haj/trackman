namespace :simulate do
  task :entered_area => :environment do
  	Traccar::Device.all.each do |device|
  		outside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << outside_position

  		liberty_statue = { :latitude => 40.689249, :longitude => -74.0445 }

  		inside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: liberty_statue[:latitude], longitude: liberty_statue[:longitude], other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << inside_position
  	end
  end
end