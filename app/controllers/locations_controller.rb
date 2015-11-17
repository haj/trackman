class LocationsController < ApplicationController

  def get_traccar_data
    lat = params[:latitude]
    lon = params[:longitude]
    device_id = params[:device_id]
    unique_id = params[:unique_id]
    position_id = params[:position_id]
    fix_time = params[:fix_time].to_time
    valid = params[:valid]
    speed = params[:speed]
    status = params[:status]
    device = Device.find_by_emei(unique_id)

    l = Location.create(device_id: device.id, latitude: lat, longitude: lon, time: fix_time, speed: speed,
        valid_position: valid, position_id: position_id, status: status)

    # l = Location.create(device_id: p.deviceId, latitude: p.latitude, longitude: p.longitude, time: p.fixTime, speed: p.speed, valid_position: p.valid, position_id: p.id)

    l.analyze_me

    # binding.pry

    # puts "!!! FROM TRACCAR !!!"
    # puts params
    render :text => ""
  end

end
