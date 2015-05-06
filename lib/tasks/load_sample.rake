require 'csv'    

# load sample data stored in data/vehicle1.txt
task :load_sample => :environment do
	filename = File.join(Rails.root, 'data', 'vehicle1.txt')
	first_row = CSV.read(filename, :headers => true).first

	company = Company.where(subdomain: "demo").first
	ActsAsTenant.current_tenant = company
	car = Car.find_or_create_by(name: first_row[0], numberplate: first_row[0])
	device = Device.find_or_create_by(name: first_row[0], emei: first_row[0], car_id: car.id, device_model_id: DeviceModel.first.id, device_type_id: DeviceType.first.id)
	traccar_device = Traccar::Device.find_or_create_by(name: first_row[0], uniqueId: first_row[0])

	# start clean 
	Traccar::Position.where(device_id: traccar_device.id).destroy_all

	counter = 0 
	day = 30.days.ago
	more = 0

	CSV.foreach(filename, :headers => true) do |row|

		counter += 1

		lng = row[2]
		lat = row[3]

		if counter % 100 == 0
			day = 30.days.ago + more.days
			more += 1
		end

		if more == 29
			return 
		end

		# set up position infos 
		time = Time.parse(row[1]).change({ year: "2015", day: day.day  })
		

		position = Traccar::Position.create!(
			altitude: 0.0, 
			course: 0.0, 
  			latitude: lat, 
  			longitude: lng, 
  			speed: Random.new.rand(100), 
  			time: time, 
  			valid: true, 
  			device_id: traccar_device.id)
		puts position.inspect
  		
	end	
end