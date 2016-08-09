class SimulationsController < ApplicationController
  def movement
    Simulation.movement(params[:car_id])

    redirect_to car_path(params[:car_id])
  end

  def speeding
    Simulation.speeding(params[:car_id])
    
    redirect_to car_path(params[:car_id])
  end

  def outside_work_hours
    Simulation.outside_work_hours(params[:car_id])
    
    redirect_to car_path(params[:car_id])
  end

  def long_pause
    Simulation.long_pause(params[:car_id])

    redirect_to car_path(params[:car_id])
  end

  def long_driving
    Simulation.long_driving(params[:car_id])

    redirect_to car_path(params[:car_id])
  end

  def enter_area
    Simulation.enter_area(params[:car_id])

    redirect_to car_path(params[:car_id])
  end

  def left_area
    Simulation.left_area(params[:car_id])

    redirect_to car_path(params[:car_id])
  end

  private
    
  # Never trust parameters from the scary internet, only allow the white list through.
  def vehicle_params
    params.require(:vehicle).permit!
  end
end
