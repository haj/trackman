class PlanTypesController < ApplicationController
  before_action :set_plan_type, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /plan_types
  # GET /plan_types.json
  def index
    @plan_types = PlanType.all
  end

  # GET /plan_types/1
  # GET /plan_types/1.json
  def show
  end

  # GET /plan_types/new
  def new
    @plan_type = PlanType.new
  end

  # GET /plan_types/1/edit
  def edit
  end

  # POST /plan_types
  # POST /plan_types.json
  def create
    @plan_type = PlanType.new(plan_type_params)

    respond_to do |format|
      if @plan_type.save
        format.html { redirect_to @plan_type, notice: 'Plan type was successfully created.' }
        format.json { render :show, status: :created, location: @plan_type }
      else
        format.html { render :new }
        format.json { render json: @plan_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plan_types/1
  # PATCH/PUT /plan_types/1.json
  def update
    respond_to do |format|
      if @plan_type.update(plan_type_params)
        format.html { redirect_to @plan_type, notice: 'Plan type was successfully updated.' }
        format.json { render :show, status: :ok, location: @plan_type }
      else
        format.html { render :edit }
        format.json { render json: @plan_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plan_types/1
  # DELETE /plan_types/1.json
  def destroy
    @plan_type.destroy
    respond_to do |format|
      format.html { redirect_to plan_types_url, notice: 'Plan type was successfully destroyed.' }
      format.json { head :no_content }
    end
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
