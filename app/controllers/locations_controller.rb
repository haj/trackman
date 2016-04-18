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

    position = Traccar::Position.find position_id
    jsoned_xml = JSON.pretty_generate(Hash.from_xml(position.other))
    ignite = JSON[jsoned_xml]["info"]["power"]

    l = Location.create(device_id: device.id, latitude: lat, longitude: lon, time: fix_time, speed: speed, valid_position: valid,
        position_id: position_id, status: status)

    if ignite != ""
        l.ignite = ignite
    end

    # puts l.inspect

    # logger.warn l.valid_position
    l.analyze_me

    puts "!!! FROM TRACCAR !!!"
    puts params
    render :text => ""
  end

  def get_car_route
  	car_id = params["car_id"]
  	date = params["date"]
  	c = Car.find car_id
        positions = Location.find_by_sql(["select latitude, longitude, speed, state, address, step from locations where DATE(time) = ? and device_id = ?", date, c.device.id])
        # positions = Traccar::Position.select(:address, :altitude, :latitude, :longitude, :speed, :course).where("DATE(fixTime) = ? and deviceId = ?", date, car_id)
        render json: positions.to_json
  end


end
