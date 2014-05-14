class Api::CarTypesController < ApplicationController
  before_action :set_car_type, only: [:show, :edit, :update, :destroy]
  
  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json


  def index
    @car_types = CarType.all
  end


  def show
  end

  def new
    @car_type = CarType.new
  end

  def edit
  end

  def create
    @car_type = CarType.new(car_type_params)

    respond_to do |format|
      if @car_type.save
        format.html { redirect_to @car_type, notice: 'Car type was successfully created.' }
        format.json { render action: 'show', status: :created, location: @car_type }
      else
        format.html { render action: 'new' }
        format.json { render json: @car_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @car_type.update(car_type_params)
        format.html { redirect_to @car_type, notice: 'Car type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car_type.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @car_type.destroy
    respond_to do |format|
      format.html { redirect_to car_types_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_type
      @car_type = CarType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_type_params
      params.require(:car_type).permit(:name)
    end
end
