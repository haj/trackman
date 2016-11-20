class TraccarWorker
  include Sidekiq::Worker
  sidekiq_options retry: true
  sidekiq_options queue: "traccar"
  sidekiq_options unique: :while_executing
  
  def perform
    last_position_id = ImportStatus.where.not(position_id: nil).last

    position = 
      if last_position_id
        Traccar::Position.where("id > ?", last_position_id.position_id).first
      else
        nil
      end

    if !ImportStatus.where(position_id: position.try(:id)).present? && position 
      ImportStatus.create(position_id: position.try(:id))

      lat         = position.latitude
      lon         = position.longitude
      device_id   = position.deviceid
      unique_id   = position.device.uniqueid
      position_id = position.try(:id)
      fix_time    = position.fixtime
      valid       = position.valid
      speed       = position.speed # Speed in Knots
      status      = position.course
      device      = Device.find_by_emei(unique_id)
      position    = Traccar::Position.find position_id
      ignite      = JSON.parse(position.attributes["attributes"])["power"] rescue nil

      # Conversion of speed from knots to km/h
      speed = speed.to_f * 1.852

      l = Location.create(device_id: device.try(:id), latitude: lat, longitude: lon, time: fix_time, speed: speed, valid_position: valid,
          position_id: position_id, status: status, ignite: ignite)

      Location.where("device_id = ? and DATE(time) = ? and id != ?", l.device_id, l.time.to_date, l.id) do |loc|
        if loc.time > l.time
          loc.analyze_me
        end
      end

      l.analyze_me
    end
  end

end