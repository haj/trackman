task :capture_state => :environment do
	Company.all.each do |company|
		puts "Company : #{company.name} => "
		company.cars.each do |car|
			puts car.capture_state
		end
	end
end