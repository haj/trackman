class SimulationWorker
  include Sidekiq::Worker

  def perform
    5000.times do |i|
      address        = Faker::Address.street_address
      lat            = Faker::Number.between(107.599, 106.8294444)
      lon            = Faker::Number.between(-6.92714, -6.1744444)
      fixtime        = Location.last.time + 1.minutes
      speed          = 10
      valid_position = true
      position_id    = Traccar::Position.last.id
      status         = "0.0"
      ignite         = i % 5 == 0 ? false : true

      l = Location.create(
        device_id: Device.last.id,
        latitude: lat,
        longitude: lon,
        time: fixtime,
        speed: speed,
        valid_position: valid_position,
        position_id: position_id,
        status: status,
        ignite: ignite
      )

      l.analyze_me

      sleep 2
    end
  end
end
