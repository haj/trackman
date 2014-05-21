namespace :cars do
  task :refresh => :environment do
  	Company.all.each do |company|
  		puts "Company : #{company.name} => "
  		company.cars.each do |car|
  			puts car.update_movement_status
  		end
  	end
  end
end