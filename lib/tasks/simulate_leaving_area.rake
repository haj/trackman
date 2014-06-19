namespace :simulate do
  task :left_area => :environment do
  	Traccar::Device.all.each do |device|
  		inside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 40.691393, longitude: -74.043367, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << inside_position

  		outside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << outside_position
  	end
  end
end