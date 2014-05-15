class Api::CarsController < ApplicationController
  before_action :set_car, only: [:show, :edit, :update, :destroy]

  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json

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

  def index
    @cars = apply_scopes(Car).all
    positions = Car.all_positions(@cars)
    @hash = Gmaps4rails.build_markers(positions) do |position, marker|
      marker.lat position[:latitude].to_s
      marker.lng position[:longitude].to_s
    end
  end

  def live_map
    @cars = Car.all
    gon.data = @hash
    gon.url = "/cars"
    gon.map_id = "cars_index"
    gon.query_params = request.query_parameters
  end

  def show
    @position = Car.find(params[:id]).last_position
    @collection =  [@position]
    @hash = Gmaps4rails.build_markers(@collection) do |position, marker|
      marker.lat position[:latitude].to_s
      marker.lng position[:longitude].to_s
    end
    gon.data = @hash
    gon.url = "/cars/#{@car.id}"
    gon.map_id = "cars_show"
    gon.refresh_button = ".refresh_car"
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
      if device_params.has_key?('device_id') && !device_params['device_id'].empty?
        device = Device.find(device_params['device_id'])
        if !device.nil?
          device.update_attribute(:car_id, @car.id)
        end
      end
      redirect_to @car, notice: 'Car was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @car.update(car_params)
        if device_params.has_key?('device_id') && !device_params['device_id'].empty?
          # release other device 
          if @car.has_device?
            @car.device.update_attribute(:car_id, nil)
          end
          # attach new device 
          device = Device.find(device_params['device_id'])
          device.update_attribute(:car_id, @car.id)
        elsif device_params.has_key?('device_id')
          if @car.has_device?
            @car.device.update_attribute(:car_id, nil)
          end 
        end

        format.html { redirect_to @car, notice: 'Car was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @car.destroy
    respond_to do |format|
      format.html { redirect_to cars_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car
      @car = Car.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_params
      params.require(:car).permit(:mileage, :numberplate, :car_model_id, :car_type_id, :registration_no, :year, :color, :group_id, :user_id)
    end

    def device_params
      params.permit(:device_id)
    end
end
