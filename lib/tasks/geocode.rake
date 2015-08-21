require_relative '../../app/workers/geocoder_worker'
 
namespace :geocoder do
 
	task :reverse => :environment do
		# GeocoderWorker.perform_async
		Traccar::Position.geocode
	end
	
end