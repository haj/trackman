namespace :check do
  task :which_cars_are_moving => :environment do
  	Company.all.each do |company|
  		puts "Company : #{company.name} => "
  		company.cars.each do |car|
  			puts car.update_movement_status
  		end
  	end
  end
end