class DeviceModelsController < ApplicationController
  before_action :set_device_model, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  has_scope :by_device_manufacturer

  # GET /device_models
  # GET /device_models.json
  def index
    @q = apply_scopes(DeviceModel).all.search(params[:q])
    @device_models = @q.result(distinct: true)
    # respond_to do |format|
    #   format.html {render :layout => "index_template"}
    # end
  end

  # GET /device_models/1
  # GET /device_models/1.json
  def show
  end

  # GET /device_models/new
  def new
    @device_model = DeviceModel.new
  end

  # GET /device_models/1/edit
  def edit
  end

  # POST /device_models
  # POST /device_models.json
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

  # PATCH/PUT /device_models/1
  # PATCH/PUT /device_models/1.json
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

  def batch_destroy
    device_model_ids = params[:device_model_ids]
    device_model_ids.each do |device_model_id|
      @device_model = DeviceModel.find(device_model_id)
      @device_model.destroy
    end
    redirect_to device_models_path
  end

  # DELETE /device_models/1
  # DELETE /device_models/1.json
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
