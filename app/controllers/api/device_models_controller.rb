class Api::DeviceModelsController < ApplicationController
  before_action :set_device_model, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json

  def index
    @device_models = DeviceModel.all
  end

  def show
  end

  def new
    @device_model = DeviceModel.new
  end

  def edit
  end

  def create
    @device_model = DeviceModel.new(device_model_params)

    respond_to do |format|
      if @device_model.save
        format.html { redirect_to @device_model, notice: 'Device model was successfully created.' }
        format.json { render action: 'show', status: :created, location: @device_model }
      else
        format.html { render action: 'new' }
        format.json { render json: @device_model.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @device_model.update(device_model_params)
        format.html { redirect_to @device_model, notice: 'Device model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @device_model.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device_model.destroy
    respond_to do |format|
      format.html { redirect_to device_models_url }
      format.json { head :no_content }
    end
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
