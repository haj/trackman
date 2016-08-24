namespace :migrate do
  desc "Migrate Devices"

  task :devices => :environment do
    Device.all.each do |device|
      Traccar::Device.create(name: device.name, uniqueid: device.emei, lastupdate: Time.now)
    end
  end
end