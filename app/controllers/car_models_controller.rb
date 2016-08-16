class CarModelsController < ApplicationController
  # Include module / class
  include Batchable

  # Initialize something from GEM
  load_and_authorize_resource
  has_scope :by_car_manufacturer

  # Callback controller
  before_action :set_car_model, only: [:show, :edit, :update, :destroy]


  # GET /car_models
  # GET /car_models.json
  def index
    @q = apply_scopes(CarModel).search(params[:q])
    @car_models = @q.result(distinct: true).page(params[:page])

    respond_with(@car_models)
  end

  # GET /car_models/1
  # GET /car_models/1.json
  def show
    respond_with(@car_model)
  end

  # GET /car_models/new
  def new
    @car_model = CarModel.new

    respond_with(@car_model)
  end

  # GET /car_models/1/edit
  def edit
    respond_with(@car_model)
  end

  # POST /car_models
  # POST /car_models.json
  def create
    @car_model = CarModel.new(car_model_params)

    if @car_model.save
      respond_with(@car_model, location: car_models_url, notice: 'Car model was successfully created.')
    else
      respond_with(@car_model)
    end
  end

  # PATCH/PUT /car_models/1
  # PATCH/PUT /car_models/1.json
  def update
    if @car_model.update(car_model_params)
      respond_with(@car_model, location: car_models_url, notice: 'Car model was successfully updated.')
    else
      respond_with(@car_model)
    end
  end

  # DELETE /car_models/1
  # DELETE /car_models/1.json
  def destroy
    @car_model.destroy

    respond_with(@car_model, location: car_models_url)
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
