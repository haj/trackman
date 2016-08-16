class RulesController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_rule, only: [:show, :edit, :update, :destroy, :rule_params_list]
  
  # GET /rules
  # GET /rules.json
  def index
    @rules = Rule.page(params[:page])

    respond_with(@rules)
  end

  # GET /rules/1
  # GET /rules/1.json
  def show
    respond_with(@rule)
  end

  # GET /rules/new
  def new
    @rule = Rule.new

    respond_with(@rule)
  end

  # GET /rules/1/edit
  def edit
    respond_with(@rule)
  end

  # POST /rules
  # POST /rules.json
  def create
    @rule = Rule.new(rule_params)

    if @rule.save
      respond_with(@rule, location: rules_url, notice: 'Rule was successfully created.')
    else
      respond_with(@rule)
    end
  end

  # PATCH/PUT /rules/1
  # PATCH/PUT /rules/1.json
  def update
    if @rule.update(rule_params)
      respond_with(@rule, location: rules_url, notice: 'Rule was successfully updated.')
    else
      respond_with(@rule)
    end
  end

  # DELETE /rules/1
  # DELETE /rules/1.json
  def destroy
    @rule.destroy

    respond_with(rule, location: rules_url, notice: 'RUle was successfully destroyed.')
  end

  # GET /rules/:id/rule_params_list || rule_params_list_rule_path(:id)
  # I don't know this method. Please add some information here if you made this method/
  def rule_params_list
    render json: @rule.params
  end

  # GET /rules/regions || regions_rules_path
  # Select all regions available and return it in a JSON object
  def regions
    @regions = Region.all

    render json: @regions.to_json(:include => :vertices)
  end

  # GET /rules/work_schedules || work_schedules_rules_path
  # Retrieve all workschedules
  def work_schedules
    @work_schedules = WorkSchedule.all

    render json: @work_schedules.to_json
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rule
    @rule = Rule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rule_params
    params.require(:rule).permit(:name, :method_name, parameters_attributes: [:id, :name, :data_type, :_destroy])
  end
end
