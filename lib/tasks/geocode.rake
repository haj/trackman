task :geocode => :environment do
	Traccar::Position.geocode
end