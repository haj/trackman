class Api::CarManufacturersController < ApplicationController
  before_action :set_car_manufacturer, only: [:show, :edit, :update, :destroy]

  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json


  def index
    @car_manufacturers = CarManufacturer.all
  end

  def show
  end

  def new
    @car_manufacturer = CarManufacturer.new
  end

  def edit
  end

  def create
    @car_manufacturer = CarManufacturer.new(car_manufacturer_params)

    respond_to do |format|
      if @car_manufacturer.save
        format.html { redirect_to @car_manufacturer, notice: 'Car manufacturer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @car_manufacturer }
      else
        format.html { render action: 'new' }
        format.json { render json: @car_manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @car_manufacturer.update(car_manufacturer_params)
        format.html { redirect_to @car_manufacturer, notice: 'Car manufacturer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car_manufacturer.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @car_manufacturer.destroy
    respond_to do |format|
      format.html { redirect_to car_manufacturers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_manufacturer
      @car_manufacturer = CarManufacturer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_manufacturer_params
      params.require(:car_manufacturer).permit(:name)
    end
end
