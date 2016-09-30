class CarsController < ApplicationController
  # Include module / class
  add_breadcrumb "Vehicles", :cars_url

  include Batchable
  include Breadcrumbable

  # Initialize something from GEM
  load_and_authorize_resource except: :last_position

  # Callback controller
  before_action :set_car, only: [:edit, :update, :destroy, :show, :reports, :positions, :last_position]

  # GET /cars || cars_path
  # This list vehicles and enable the user to manage vehicles
  def index
    @q    = apply_scopes(Car).includes(:car_model, :car_type).search(params[:q])
    @cars = @q.result(distinct: true).page(params[:page])

    respond_with(@cars)
  end

  # GET /cars/:id || car_path(:id)
  # Show specific car
  def show
    @alarms = @car.alarms

    respond_with(@car)
  end

  # GET /cars/new || new_car_path
  # New Car Form
  def new
    @car = Car.new

    respond_with(@car)
  end

  # GET /cars/:id/edit || edit_car_path(:id)
  # Edit Car Form
  def edit
    @device = Device.specific_car(params[:id])

    respond_with(@car)
  end

  # POST /cars || cars_path
  # Create a new car
  def create
    @car = Car.new(car_params)

    if @car.save
      respond_with(@car, location: cars_url, notice: 'Vehicle was successfully created.')
    else
      respond_with(@car)
    end
  end

  # PUT /cars/:id || car_path(:id)
  # Update specific car
  def update
    if @car.update(car_params)
      respond_with(@car, location: cars_url, notice: 'Vehicle was successfully updated.')
    else
      respond_with(@car)
    end
  end

  # Delete /cars/:id || car_path(:id)
  # Delete specific car
  def destroy
    @car.destroy

    respond_with(@car, location: cars_url)
  end

  # This list vehicles and enable the user to get vehicle positions
  def history
    @q = apply_scopes(Car).all.search(params[:q])
    @cars = @q.result(distinct: true)

    respond_with(@cars)
  end

  def reports
    respond_with(@car)
  end
  
  def positions
    @alarms = @car.alarms
    if @car.has_device?
      timezone = current_user.time_zone.to_s
      
      Time.use_zone(timezone) do
        dates = params[:dates]
        @positions = @car.positions_with_dates(dates, timezone)        
        @title = "Last #{@positions.count} positions" if dates.nil?

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

  def last_position
    accepted_user = Order.find(params[:order_id]).accepted_user
    location      = @car.locations.last

    if accepted_user.try(:accepted_destination)
      accepted_user.accepted_destination.update(last_location_id: location.id)
    else
      accepted_user.build_accepted_destination(first_location_id: location.id, last_location_id: location.id)
      accepted_user.save!
    end

    render json: location
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
    params.require(:car).permit(:name, :mileage, :numberplate, :work_schedule_id, :car_model_id, :car_type_id, :device_id, :registration_no, :user_id, :year, :color, :group_id, alarm_ids: [])
  end

  def device_params
    params.permit(:device_id)
  end

  def user_params
    params.permit(:user_id)
  end

end
