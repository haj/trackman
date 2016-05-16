class TraccarWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  sidekiq_options queue: "traccar"

  def perform(params)
      lat = params[:latitude]
      lon = params[:longitude]
      device_id = params[:device_id]
      unique_id = params[:unique_id]
      position_id = params[:position_id]
      fix_time = params[:fix_time]
      valid = params[:valid]
      speed = params[:speed]
      status = params[:status]
      device = Device.find_by_emei(unique_id)

      logger.warn "Device : #{device}"
      logger.warn "Params : #{params}"

      position = Traccar::Position.find(position_id)
      logger.warn "Position ID : #{position}"

      jsoned_xml = JSON.pretty_generate(Hash.from_xml(position.other))
      ignite = JSON[jsoned_xml]["info"]["power"]

      logger.info "Time : #{fix_time}"

      l = Location.create(device_id: device.id, latitude: lat, longitude: lon, time: fix_time, speed: speed, valid_position: valid,
        position_id: position_id, status: status)

      if ignite != ""
        l.ignite = ignite
      end

      l.analyze_me

      logger.info "Sidekiq Job Finished !"
      logger.debug params
  end

end