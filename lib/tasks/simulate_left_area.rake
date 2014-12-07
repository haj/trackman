# This will go over each device in the Traccar database and generate positions 
# so it would look like the car using this device left a certain area
namespace :simulate do
  task :left_area => :environment do
  	Traccar::Device.all.each do |device|

  		liberty_statue = { :latitude => 40.689249, :longitude => -74.0445 }

  		inside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: liberty_statue[:latitude], longitude: liberty_statue[:longitude], other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << inside_position

  		outside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: device.id)
  		device.positions << outside_position
  	end
  end
end