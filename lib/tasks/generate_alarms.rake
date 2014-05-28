namespace :generate do
  task :alarms => :environment do
  	Company.all.each do |company|
  		puts "Company : #{company.name} => "
  		company.cars.each do |car|
  			puts car.generate_alarms
  		end
  	end
  end
end