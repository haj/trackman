class DeviceModelsController < ApplicationController
  # Include module / class
  include Batchable

  # Initialize something from GEM
  load_and_authorize_resource
  has_scope :by_device_manufacturer

  # Callback controller
  before_action :set_device_model, only: [:show, :edit, :update, :destroy]

  # GET /device_models
  # GET /device_models.json
  def index
    @q = apply_scopes(DeviceModel).all.search(params[:q])
    @device_models = @q.result(distinct: true).page(params[:page])

    respond_with(@device_models)
  end

  # GET /device_models/1
  # GET /device_models/1.json
  def show
    respond_with(@device_model)
  end

  # GET /device_models/new
  def new
    @device_model = DeviceModel.new

    respond_with(@device_model)
  end

  # GET /device_models/1/edit
  def edit
    respond_with(@device_model)
  end

  # POST /device_models
  # POST /device_models.json
  def create
    @device_model = DeviceModel.new(device_model_params)

    if @device_model.save
      respond_with(@device_model, location: device_models_url, notice: 'Device model was successfully created.')
    else
      respond_with(@device_model)
    end
  end

  # PATCH/PUT /device_models/1
  # PATCH/PUT /device_models/1.json
  def update
    if @device_model.update(device_model_params)
      respond_with(@device_model, location: device_models_url, notice: 'Device model was successfully updated.')
    else
      respond_with(@device_model)
    end
  end

  # DELETE /device_models/1
  # DELETE /device_models/1.json
  def destroy
    @device_model.destroy

    respond_with(@device_model, location: device_models_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_device_model
    @device_model = DeviceModel.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def device_model_params
    params.require(:device_model).permit(:name, :device_manufacturer_id, :protocol)
  end

end
