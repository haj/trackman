task :simulate_route => :environment do

	Device.where(emei:"621184901").first.traccar_device.positions.destroy_all

	positions = [
		[37.331863,-122.032445],
		[37.328714,-122.032426],
		[37.325451,-122.032402],
		[37.320387,-122.032415]
	]


	positions.reverse.each do |position|
		Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: position[0], longitude: position[1], other: "<info><protocol>t55</protocol></info>", speed: 0.0, time: Time.now, valid: true, device_id: 1)
	end

end