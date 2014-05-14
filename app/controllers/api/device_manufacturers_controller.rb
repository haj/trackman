class Api::DeviceManufacturersController < ApplicationController
  before_action :set_device_manufacturer, only: [:show, :edit, :update, :destroy]
  
  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json

  def index
    @device_manufacturers = DeviceManufacturer.all
  end

  def show
  end

  def new
    @device_manufacturer = DeviceManufacturer.new
  end

  def edit
  end

  def create
    @device_manufacturer = DeviceManufacturer.new(device_manufacturer_params)

    respond_to do |format|
      if @device_manufacturer.save
        format.html { redirect_to @device_manufacturer, notice: 'Device manufacturer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @device_manufacturer }
      else
        format.html { render action: 'new' }
        format.json { render json: @device_manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @device_manufacturer.update(device_manufacturer_params)
        format.html { redirect_to @device_manufacturer, notice: 'Device manufacturer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @device_manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device_manufacturer.destroy
    respond_to do |format|
      format.html { redirect_to device_manufacturers_url }
      format.json { head :no_content }
    end
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
