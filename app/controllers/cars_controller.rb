class CarsController < ApplicationController
  before_action :set_car, only: [:edit, :update, :destroy]
  load_and_authorize_resource

  # This list vehicles and enable the user to get vehicle positions
  def history
    @q = apply_scopes(Car).all.search(params[:q])
    @cars = @q.result(distinct: true)
    respond_to do |format|
      format.html
    end
  end

  def reports
    @car = Car.find(params[:id])
  end

  def positions
    @car = Car.find(params[:id])
    @alarms = @car.alarms
    if @car.has_device?
      timezone = current_user.time_zone.to_s
      
      Time.use_zone(timezone) do
        dates = params[:dates]
        @positions = @car.positions_with_dates(dates, timezone)
        if dates.nil?
          @title = "Last #{@positions.count} positions"
        end
        @markers = Traccar::Position.markers(@positions)        
        gon.watch.data = @markers
        gon.push({
          :url => "/cars/#{@car.id}",
          :map_id => "cars_show",
          :resource => "cars"
        })
      end

      respond_to do |format|
        format.html
        format.pdf do
          render pdf: "positions"   # Excluding ".pdf" extension.
        end
      end
    else
      logger.warn "Car has no device"
    end
  end

  def pdf
    @position = Traccar::Position.last
    
  end

  # This list vehicles and enable the user to manage vehicles
  def index
    @q = apply_scopes(Car).all.search(params[:q])
    @cars = @q.result(distinct: true)
    respond_to do |format|
      format.html
    end
  end

  def show
    @car = Car.find(params[:id])
    @alarms = @car.alarms
  end

  def new
    @car = Car.new
  end

  def edit
    @device = Device.where(:car_id => params[:id])
  end

  def create
    @car = Car.new(car_params)
    if @car.save

      # assign device to this car
      if device_params.has_key?('device_id') && !device_params['device_id'].empty?
        device = Device.find(device_params['device_id'])
        if !device.nil?
          device.update_attribute(:car_id, @car.id)
        end
      end

      # assign driver to this car 
      if !user_params['user_id'].empty?
        user = User.find(user_params[:user_id]) 
        user.update_attribute(:car_id, @car.id)
      end

      redirect_to @car, notice: 'Vehicle was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @car.update(car_params)

        if device_params.has_key?('device_id') && !device_params['device_id'].empty?
          
          # release previous device 
          if @car.has_device?
            @car.device.update_attribute(:car_id, nil)
          end

          # assign new device 
          device = Device.find(device_params['device_id'])
          device.update_attribute(:car_id, @car.id)

        elsif device_params.has_key?('device_id')
          if @car.has_device?
            @car.device.update_attribute(:car_id, nil)
          end 
        end

         # assign driver to this car
        if !user_params['user_id'].empty?
          user = User.find(user_params[:user_id]) 
          user.update_attribute(:car_id, @car.id)
        end

        format.html { redirect_to @car, notice: 'Vehicle was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def batch_destroy
    car_ids = params[:car_ids]
    car_ids.each do |car_id|
      @car = Car.find(car_id)
      @car.destroy
    end
    redirect_to cars_path
  end

  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url }
      format.json { head :no_content }
    end
  end

  ##########
  ## Scopes
  ##########

  has_scope :by_car_model
  has_scope :by_car_type
  has_scope :trackable do |controller, scope, value|
    if value == "all"
      scope
    elsif value == "true"
      scope.traceable
    elsif value == "false"
      scope.untraceable
    end 
  end

  has_scope :has_driver do |controller, scope, value|
    if value == "all"
      scope
    elsif value == "true"
      scope.with_driver
    elsif value == "false"
      scope.without_driver
    end 
  end

  ###########
  ## Private
  ###########

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params.require(:car).permit(:name, :mileage, :numberplate, :work_schedule_id, :car_model_id, :car_type_id, :registration_no, :year, :color, :group_id, alarm_ids: [])
    end

    def device_params
      params.permit(:device_id)
    end

    def user_params
      params.permit(:user_id)
    end

end