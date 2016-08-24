class CarStatisticsController < ApplicationController  
  # GET /car_statistics || car_statistics_path
  # Return car statistics with specific car and date; Render in JSON
  def get_stats
    stats = CarStatistic.car_date(params['car_id'], params['date']).first
    render json: stats.to_json
  end
end