task :check_alarms => :environment do
	Company.all.each do |company|
		puts "#### Company - #{company.name}  "
		company.cars.each do |car|
			car.check_alarms
		end
	end
end