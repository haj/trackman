namespace :devices_movement do
  task :refresh => :environment do
  	Company.all.each do |company|
  		puts "Company : #{company.name} => "
  		company.devices.each do |device|
  			puts device.update_movement_status
  		end
  	end
  end
end