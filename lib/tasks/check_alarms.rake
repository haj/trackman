namespace :alarms do
	task :check => :environment do
		Company.all.each do |company|
			#puts "## Company  #{company.name}  "
			company.cars.each do |car|
				#puts " ## Car : #{car.name}"
				car.check_alarms
				car.capture_state
			end
		end
	end
end