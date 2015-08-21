class GeocoderWorker
	include Sidekiq::Worker

	def perform
		Traccar::Position.geocode
	end
end