class SimulationsController < ApplicationController


  def movement
    car = Car.find(params[:car_id])
    Simulation.movement(params[:car_id])
    redirect_to car_path(car)
  end

  def speeding
    render text: "speeding"
    return 
  end

  def outside_work_hours
    render text: "outside_work_hours"
    return
  end

  def long_pause
    render text: "long_pause"
    return
  end

  def long_driving
    render text: "long_driving"
    return
  end

  def enter_area
    render text: "enter_area"
    return
  end

  def left_area
    render text: "left_area"
    return
  end






  private
    

    # Never trust parameters from the scary internet, only allow the white list through.
    def vehicle_params
      params.require(:vehicle).permit!
    end
end
