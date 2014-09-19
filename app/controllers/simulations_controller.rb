class SimulationsController < ApplicationController


  def movement
    car = Car.find(params[:car_id])
    Simulation.movement(params[:car_id])
    redirect_to car_path(car)
  end

  def speeding
    car = Car.find(params[:car_id])
    Simulation.speeding(params[:car_id])
    redirect_to car_path(car)
  end

  def outside_work_hours
    car = Car.find(params[:car_id])
    Simulation.outside_work_hours(params[:car_id])
    redirect_to car_path(car)
  end

  def long_pause
   car = Car.find(params[:car_id])
    Simulation.long_pause(params[:car_id])
    redirect_to car_path(car)
  end

  def long_driving
    car = Car.find(params[:car_id])
    Simulation.long_driving(params[:car_id])
    redirect_to car_path(car)
  end

  def enter_area
    car = Car.find(params[:car_id])
    Simulation.enter_area(params[:car_id])
    redirect_to car_path(car)
  end

  def left_area
    car = Car.find(params[:car_id])
    Simulation.left_area(params[:car_id])
    redirect_to car_path(car)
  end






  private
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit!
    end
end
