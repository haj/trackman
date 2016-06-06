class CarStatisticsController < ApplicationController
  
  def get_stats
    stats = CarStatistic.where(car_id: params["car_id"], time: params["date"]).first
    render json: stats.to_json
  end
end