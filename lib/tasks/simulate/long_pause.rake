# This will go over each device in the Traccar database and generate positions 
# so it would look like the car using this device was involved in a long pause by the driver
namespace :simulate do
  task :long_pause => :environment do
  	time = 2.minutes.ago
  	20.times do 
  		state = State.create(no_data: false, moving: false, car_id: Car.first.id, created_at: time, updated_at: time , speed: 0, driver_id: User.first, device_id: Device.first)
  		state.save!
  		time = time - 30.minutes
  	end
  end
end