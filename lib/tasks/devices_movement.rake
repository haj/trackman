namespace :devices_movement do
  task :refresh => :environment do
  	Company.all.each do |company|
  		puts "#{company.name} => "
  		company.devices.each do |device|
  			puts device.refresh_status
  		end
  	end
  end
end