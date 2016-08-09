class PlansController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_plan, only: [:show, :edit, :update, :destroy]

  # GET /plans
  # GET /plans.json
  def index
    @plans = Plan.all

    respond_with(@plans)
  end

  # GET /plans/1
  # GET /plans/1.json
  def show
    respond_with(@plan)
  end

  # GET /plans/new
  def new
    @plan = Plan.new

    respond_with(@plan)
  end

  # GET /plans/1/edit
  def edit
    respond_with(@plan)
  end

  # POST /plans
  # POST /plans.json
  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      respond_with(@plan, location: @plan, notice: 'Plan was successfully created.')
    else
      respond_with(@plan)
    end
  end

  # PATCH/PUT /plans/1
  # PATCH/PUT /plans/1.json
  def update
    if @plan.update(plan_params)
      respond_with(@plan, location: @plan, notice: 'Plan was successfully updated.')
    else
      respond_with(@plan)
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.json
  def destroy
    @plan.destroy

    respond_with(@plan, location: plans_url, notice: 'Plan was successfully destroyed')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def plan_params
    params.require(:plan).permit(:interval, :plan_type_id, :price, :currency)
  end
end
