class CarTypesController < ApplicationController
  # Include module / class
  include Batchable

  # Initialize something from GEM
  load_and_authorize_resource

  # Callback controller
  before_action :set_car_type, only: [:show, :edit, :update, :destroy]

  # GET /car_types
  # GET /car_types.json
  def index
    @q = CarType.search(params[:q])
    @car_types = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.js
      format.html
    end
  end

  # GET /car_types/1
  # GET /car_types/1.json
  def show
    respond_with(@car_type)
  end

  # GET /car_types/new
  def new
    @car_type = CarType.new

    respond_with(@car_type)
  end

  # GET /car_types/1/edit
  def edit
    respond_with(@car_type)
  end

  # POST /car_types
  # POST /car_types.json
  def create
    @car_type = CarType.new(car_type_params)

    if @car_type.save
      respond_with(@car_type, location: car_types_url, notice: 'Car type was successfully created.')
    else
      respond_with(@car_type)
    end
  end

  # PATCH/PUT /car_types/1
  # PATCH/PUT /car_types/1.json
  def update
    if @car_type.update(car_type_params)
      respond_with(@car_type, location: car_types_url, notice: 'Car type was successfully updated.')
    else
      respond_with(@car_type)
    end
  end

  # DELETE /car_type/:id || car_type_path(:id)
  # Delete specific car type
  def destroy
    @car_type.destroy

    respond_with(@car_type, location: car_types_url)
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
