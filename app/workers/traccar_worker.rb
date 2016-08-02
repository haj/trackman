class TraccarWorker
  include Sidekiq::Worker
  sidekiq_options retry: true
  sidekiq_options queue: "traccar"
  sidekiq_options unique: :while_executing
  
  def perform
    last_position_id = ImportStatus.last

    position = 
      if last_position_id
        Traccar::Position.where("id > ?", last_position_id.position_id).first
      else
        Traccar::Position.last
      end

    ImportStatus.create(position_id: position.id)

    lat = position.latitude
    lon = position.longitude
    device_id = position.deviceid
    unique_id = position.device.uniqueid
    position_id = position.id
    fix_time = position.fixtime
    valid = position.valid
    speed = position.speed # Speed in Knots
    status = position.course
    device = Device.find_by_emei(unique_id)

    position = Traccar::Position.find position_id

    jsoned_xml = JSON.pretty_generate(Hash.from_xml(position.other
      )) rescue nil
    ignite = JSON[jsoned_xml]["info"]["power"] rescue ""

    # Conversion of speed from knots to km/h
    speed = speed.to_f * 1.852

    l = Location.create(device_id: device.id, latitude: lat, longitude: lon, time: fix_time, speed: speed, valid_position: valid,
        position_id: position_id, status: status, ignite: false )

    if ignite != ""
      l.ignite = ignite
    end

    Location.where("device_id = ? and DATE(time) = ? and id != ?", l.device_id, l.time.to_date, l.id) do |loc|
      if loc.time > l.time
        loc.analyze_me
      end
    end

    l.analyze_me
  end

end