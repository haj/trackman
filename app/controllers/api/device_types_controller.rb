class Api::DeviceTypesController < ApplicationController
  before_action :set_device_type, only: [:show, :edit, :update, :destroy]
  
  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json

  def index
    @device_types = DeviceType.all
  end

  def show
  end

  def new
    @device_type = DeviceType.new
  end

  def edit
  end

  def create
    @device_type = DeviceType.new(device_type_params)

    respond_to do |format|
      if @device_type.save
        format.html { redirect_to @device_type, notice: 'Device type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @device_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @device_type.update(device_type_params)
        format.html { redirect_to @device_type, notice: 'Device type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @device_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @device_type.destroy
    respond_to do |format|
      format.html { redirect_to device_types_url }
      format.json { head :no_content }
    end
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
