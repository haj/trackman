class Api::CarModelsController < ApplicationController
  before_action :set_car_model, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json


  def index
    @car_models = CarModel.all
  end

  def show
  end

  def new
    @car_model = CarModel.new
  end

  def edit
  end

  def create
    @car_model = CarModel.new(car_model_params)

    respond_to do |format|
      if @car_model.save
        format.html { redirect_to @car_model, notice: 'Car model was successfully created.' }
        format.json { render action: 'show', status: :created, location: @car_model }
      else
        format.html { render action: 'new' }
        format.json { render json: @car_model.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @car_model.update(car_model_params)
        format.html { redirect_to @car_model, notice: 'Car model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @car_model.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @car_model.destroy
    respond_to do |format|
      format.html { redirect_to car_models_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_car_model
      @car_model = CarModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def car_model_params
      params.require(:car_model).permit(:name, :car_manufacturer_id)
    end
end
