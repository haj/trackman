class CarManufacturersController < ApplicationController
  # Include module / class
  include Batchable

  # Initialize something from GEM
  load_and_authorize_resource

  # Callback controller
  before_action :set_car_manufacturer, only: [:show, :edit, :update, :destroy]


  # GET /car_manufacturers
  def index
    @q = CarManufacturer.search(params[:q])
    @car_manufacturers = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /car_manufacturers/1
  def show
    respond_with(@car_manufacturer)
  end

  # GET /car_manufacturers/new
  def new
    @car_manufacturer = CarManufacturer.new

    respond_with(@car_manufacturer)
  end

  # GET /car_manufacturers/1/edit
  def edit
    respond_with(@car_manufacturer)
  end

  # POST /car_manufacturers
  def create
    @car_manufacturer = CarManufacturer.new(car_manufacturer_params)

    if @car_manufacturer.save
      respond_with(@car_manufacturer, location: car_manufacturers_url, notice: 'Car manufacturer was successfully created.')
    else
      respond_with(@car_manufacturer)
    end
  end

  # PATCH/PUT /car_manufacturers/1
  def update
    if @car_manufacturer.update(car_manufacturer_params)
      respond_with(@car_manufacturer, location: car_manufacturers_url, notice: 'Car manufacturer was successfully updated.')
    else
      respond_with(@car_manufacturer)
    end
  end

  # DELETE /car_manufacturers/:id
  # Delete specific car manufacture
  def destroy
    @car_manufacturer.destroy
    respond_with(@car_manufacturer, location: car_manufacturers_url)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_manufacturer
      @car_manufacturer = CarManufacturer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_manufacturer_params
      params.require(:car_manufacturer).permit(:name)
    end
end
