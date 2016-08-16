class DeviceTypesController < ApplicationController
  # Include module / class
  include Batchable

  # Initialize something from GEM
  load_and_authorize_resource

  # Callback controller
  before_action :set_device_type, only: [:show, :edit, :update, :destroy]


  # GET /device_types
  # GET /device_types.json
  def index
    @q = DeviceType.search(params[:q])
    @device_types = @q.result(distinct: true)

    respond_with(@device_types)
  end

  # GET /device_types/1
  # GET /device_types/1.json
  def show
    respond_with(@device_type)
  end

  # GET /device_types/new
  def new
    @device_type = DeviceType.new

    respond_with(@device_type)
  end

  # GET /device_types/1/edit
  def edit
    respond_with(@device_type)
  end

  # POST /device_types
  # POST /device_types.json
  def create
    @device_type = DeviceType.new(device_type_params)

    if @device_type.save
      respond_with(@device_type, location: device_types_url, notice: 'Device type was successfully created.')
    else
      respond_with(@device_type)
    end
  end

  # PATCH/PUT /device_types/1
  # PATCH/PUT /device_types/1.json
  def update
    if @device_type.update(device_type_params)
      respond_with(@device_type, location: device_types_url, notice: 'Device type was successfully updated.')
    else
      respond_with(@device_type)
    end
  end

  def destroy
    @device_type.destroy

    respond_with(@device_type, location: device_types_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device_type
    @device_type = DeviceType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_type_params
    params.require(:device_type).permit(:name)
  end
end
