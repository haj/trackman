class DeviceManufacturersController < ApplicationController
  before_action :set_device_manufacturer, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /device_manufacturers
  # GET /device_manufacturers.json
  def index
    @q = DeviceManufacturer.search(params[:q])
    @device_manufacturers = @q.result(distinct: true)
    # respond_to do |format|
    #   format.html {render :layout => "index_template"}
    # end
  end

  # GET /device_manufacturers/1
  # GET /device_manufacturers/1.json
  def show
  end

  # GET /device_manufacturers/new
  def new
    @device_manufacturer = DeviceManufacturer.new
  end

  # GET /device_manufacturers/1/edit
  def edit
  end

  # POST /device_manufacturers
  # POST /device_manufacturers.json
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

  # PATCH/PUT /device_manufacturers/1
  # PATCH/PUT /device_manufacturers/1.json
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

  def batch_destroy
    device_manufacturer_ids = params[:device_manufacturer_ids]
    device_manufacturer_ids.each do |device_manufacturer_id|
      @device_manufacturer = DeviceManufacturer.find(device_manufacturer_id)
      @device_manufacturer.destroy
    end
    redirect_to device_manufacturers_path
  end

  # DELETE /device_manufacturers/1
  # DELETE /device_manufacturers/1.json
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
