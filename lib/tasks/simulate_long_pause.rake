namespace :simulate do
  task :long_pause => :environment do
  	time = Time.now
  	20.times do 
  		state = State.create(no_data: false, moving: false, car_id: Car.first.id, created_at: time, updated_at: time , speed: 0, driver_id: User.first, device_id: Device.first)
  		state.save!
  		time = time - 30.minutes
  	end
  end
end