class LocationsController < ApplicationController

  def get_traccar_data
    lat = params[:latitude]
    lon = params[:longitude]
    device_id = params[:device_id]
    unique_id = params[:unique_id]
    position_id = params[:position_id]
    fix_time = params[:fix_time].to_time
    address = params[:address]
    valid = params[:valid]
    speed = params[:speed]
    status = params[:status]
    device = Device.find_by_emei(unique_id)

    l = Location.create(address: address, device_id: device.id, latitude: lat,
    longitude: lon, time: fix_time, speed: speed, valid_position: valid,
    position_id: position_id, status: status)

    l.analyze_me

    # binding.pry

    # puts "!!! FROM TRACCAR !!!"
    # puts params
    render :text => ""
  end

end
