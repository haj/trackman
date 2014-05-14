class Api::DevicesController < ApplicationController
  before_action :set_device, only: [:show, :edit, :update, :destroy]

  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json

  def index
    @devices = Device.all
  end

  def show
    @position = Device.find(params[:id]).last_position
    @collection =  [@position]
    @hash = Gmaps4rails.build_markers(@collection) do |position, marker|
      marker.lat position[:latitude].to_s
      marker.lng position[:longitude].to_s
    end
  end

  def new
    @device = Device.new
  end

  def edit
  end

  def create
    @device = Device.new(device_params)
    #create the device in Traccar db
    device = Traccar::Device.create(name: device_params['name'], uniqueId: device_params['emei'])
    # attach the newly created device to the admin user of the traccar db
    device.users << Traccar::User.first

    if @device.save
      redirect_to @device, notice: 'Device was successfully created.'
    else
      render :new
    end
  end

  def update
    if @device.update(device_params)
      redirect_to @device, notice: 'Device was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    # get traccar:device using device's emei
    traccar_user = Traccar::User.first
    traccar_device = Traccar::Device.where(uniqueId: @device.emei).first
    # remove join record 
    if traccar_device.users.delete(traccar_user)
      traccar_device.positions.delete_all
      traccar_device.delete
      @device.destroy
      redirect_to devices_url, notice: 'Device was successfully destroyed.'
    else
      redirect_to @device, notice: "Device couldn't be destroyed."
    end

    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_device
      @device = Device.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def device_params
      params.require(:device).permit(:name, :emei, :cost_price)
    end
end
