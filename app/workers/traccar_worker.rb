class TraccarWorker
  include Sidekiq::Worker
  sidekiq_options retry: true
  sidekiq_options queue: "traccar"

  def perform(params)
      logger.info "Sidekiq Job Started !"

      lat = params["latitude"]
      lon = params["longitude"]
      device_id = params["device_id"]
      unique_id = params["unique_id"]
      position_id = params["position_id"].to_i
      fix_time = params["fix_time"]
      valid = params["valid"]
      speed = params["speed"] # Speed in Knots
      status = params["status"]
      device = Device.find_by_emei(unique_id)

      logger.info "Params :"
      logger.info params["position_id"].inspect
      logger.info "Sleeping while position_id is #{position_id} !"
      # sleep 2
      position = Traccar::Position.find position_id
      jsoned_xml = JSON.pretty_generate(Hash.from_xml(position.other))
      ignite = JSON[jsoned_xml]["info"]["power"]

      # Conversion of speed from knots to km/h
      speed = speed.to_f * 1.852

      l = Location.create(device_id: device.id, latitude: lat, longitude: lon, time: fix_time, speed: speed, valid_position: valid,
          position_id: position_id, status: status)

      if ignite != ""
          l.ignite = ignite
      end

      Location.where("device_id = ? and DATE(time) = ? and id != ?", l.device_id, l.time.to_date, l.id) do |loc|
        if loc.time > l.time
          loc.analyze_me
        end
      end

      l.analyze_me
      logger.info params
  end

end