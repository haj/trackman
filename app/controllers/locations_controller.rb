class LocationsController < ApplicationController

  def get_traccar_data
    TraccarWorker.perform_async(params)

    render json: nil
  end

  def get_car_route
    car_id = params["car_id"]
    date = params["date"]
    c = Car.find car_id
        positions = Location.find_by_sql(["select latitude, longitude, speed, state, address, ignite_step, trip_step from locations where DATE(time) = ? and device_id = ?", date, c.device.id])
        # positions = Traccar::Position.select(:address, :altitude, :latitude, :longitude, :speed, :course).where("DATE(fixTime) = ? and deviceId = ?", date, car_id)
        render json: positions.to_json
  end
end
