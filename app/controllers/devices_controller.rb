class DevicesController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  has_scope :by_device_model
  has_scope :by_device_type
  has_scope :has_simcard do |controller, scope, value|
    if value == "all"
      scope
    elsif value == "true"
      scope.with_simcard
    elsif value == "false"
      scope.without_simcard
    end
  end

  has_scope :available do |controller, scope, value|
    if value == "all"
      scope
    elsif value == "true"
      scope.available
    elsif value == "false"
      scope.used
    end
  end


  # Callback controller
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  # GET /devices || devices_path
  # return all devices within scope
  def index
    @q       = apply_scopes(Device).all.search(params[:q])
    @devices = @q.result(distinct: true).page(params[:page])

    respond_with(@devices)
  end


  # GET /devices/1
  # GET /devices/1.json
  def show
    respond_with(@device)
  end

  # GET /devices/new
  def new
    @device = Device.new

    respond_with(@device)
  end

  # GET /devices/1/edit
  def edit
    respond_with(@device)
  end

  # POST /devices
  # POST /devices.json
  def create
    @device = Device.new(device_params)

    if @device.save
      respond_with(@device, location: devices_url, notice: 'Device was successfully created.')
    else
      respond_with(@device)
    end
  end

  # UPDATE /devices/:id || device_path(:id)
  # Update specific device
  def update
    if @device.update(device_params)
      respond_with(@device, location: devices_url, notice: 'Device was successfully updated.')
    else
      respond_with(@devices)
    end
  end

  # DELETE /devices/:id || device_path(:id)
  # Delete specific device
  def destroy
    @device.destroy
    respond_with(@device, location: devices_url, notice: 'Device was successfully destroyed')
  end

  # PUT /devices/batch_destroy || batch_destroy_devices_path
  # Destroy devices batches
  def batch_destroy
    params[:device_ids].each do |device_id|
      device = Device.find(device_id)
      device.destroy
    end

    respond_with(params[:device_ids], location: devices_path, notice: 'Devices were successfully destroyed.')
  end

  # POST  /import_devices || import_devices_path
  # Import devices
  def import
    if params[:file].present?
      status = Device.import(params[:file])
      flash[status[:alert]] = status[:message]

      respond_with(status, location: device_manage_path)
    else
      flash[:danger] = 'You need to upload at least one document (.xls / .csv / .xlsx)'

      respond_with(params[:file], location: device_manage_path)
    end
  end

  # GET /manage_devices || import_devices_path
  # Manage all available devices
  def manage
    @devices = Device.page(params[:page])

    respond_with(@devices)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device
    @device = Device.find(params[:id])
  end

  def simcard_params
    params.permit(:simcard_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_params
    params.require(:device).permit(:name, :emei, :cost_price, :car_id, :device_model_id, :device_type_id, :sim_card_id)
  end
end
