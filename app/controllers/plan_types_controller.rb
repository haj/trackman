class PlanTypesController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_plan_type, only: [:show, :edit, :update, :destroy]

  # GET /plan_types
  # GET /plan_types.json
  def index
    @plan_types = PlanType.all

    respond_with(@plan_types)
  end

  # GET /plan_types/1
  # GET /plan_types/1.json
  def show
    respond_with(@plan_type)
  end

  # GET /plan_types/new
  def new
    @plan_type = PlanType.new

    respond_with(@plan_type)
  end

  # GET /plan_types/1/edit
  def edit
    respond_with(@plan_type)
  end

  # POST /plan_types
  # POST /plan_types.json
  def create
    @plan_type = PlanType.new(plan_type_params)

    if @plan_type.save
      respond_with(@plan_type, location: @plan_type, notice: 'Plan type was successfully created.')
    else
      respond_with(@plan_type)
    end
  end

  # PATCH/PUT /plan_types/1
  # PATCH/PUT /plan_types/1.json
  def update
    if @plan_type.update(plan_type_params)
      respond_with(@plan_type, location: @plan_type, notice: 'Plan type was successfully updated.')
    else
      respond_with(@plan_type)
    end
  end

  # DELETE /plan_types/1
  # DELETE /plan_types/1.json
  def destroy
    @plan_type.destroy

    respond_with(@plan_type, location: plan_types_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan_type
    @plan_type = PlanType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_type_params
    params.require(:plan_type).permit(:name, feature_ids: [])
  end
end
