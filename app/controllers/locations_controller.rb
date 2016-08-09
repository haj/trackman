class LocationsController < ApplicationController
  # GET /trac/Data
  # Run a worker - to update location when there's an update location from a device.
  def get_traccar_data
    TraccarWorker.perform_async

    render json: nil
  end

  # GET /get_car_route
  # Get route of a car
  def get_car_route
    car       = Car.find(params['car_id'])
    positions = Location.device_with_date(params['date'], c.device_id)

    render json: positions.to_json
  end
end
