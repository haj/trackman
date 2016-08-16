class DeviceManufacturersController < ApplicationController
  # Include module / class
  include Batchable

  # Initialize something from GEM
  load_and_authorize_resource

  # Callback controller
  before_action :set_device_manufacturer, only: [:show, :edit, :update, :destroy]

  # GET /device_manufacturers
  # GET /device_manufacturers.json
  def index
    @q = DeviceManufacturer.search(params[:q])
    @device_manufacturers = @q.result(distinct: true).page(params[:page])

    respond_with(@device_manufacturers)
  end

  # GET /device_manufacturers/1
  # GET /device_manufacturers/1.json
  def show
    respond_with(@device_manufacturer)
  end

  # GET /device_manufacturers/new
  def new
    @device_manufacturer = DeviceManufacturer.new

    respond_with(@device_manufacturer)
  end

  # GET /device_manufacturers/1/edit
  def edit
    respond_with(@device_manufacturer)
  end

  # POST /device_manufacturers
  # POST /device_manufacturers.json
  def create
    @device_manufacturer = DeviceManufacturer.new(device_manufacturer_params)

    if @device_manufacturer.save
      respond_with(@device_manufacturer, location: device_manufacturers_url, notice: 'Device manufacturer was successfully created.')
    else
      respond_with(@device_manufacturer)
    end
  end

  # PATCH/PUT /device_manufacturers/1
  # PATCH/PUT /device_manufacturers/1.json
  def update
    if @device_manufacturer.update(device_manufacturer_params)
      respond_with(@device_manufacturer, location: device_manufacturers_url, notice: 'Device manufacturer was successfully updated.')
    else
      respond_with(@device_manufacturer)
    end
  end

  # DELETE /device_manufacturers/1
  # DELETE /device_manufacturers/1.json
  def destroy
    @device_manufacturer.destroy

    respond_with(@device_manufacturer, location: device_manufacturers_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device_manufacturer
    @device_manufacturer = DeviceManufacturer.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_manufacturer_params
    params.require(:device_manufacturer).permit(:name)
  end

end
