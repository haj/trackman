class ParametersController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_parameter, only: [:show, :edit, :update, :destroy]

  # GET /parameters
  # GET /parameters.json
  def index
    @parameters = Parameter.all

    respond_with(@parameters)
  end

  # GET /parameters/1
  # GET /parameters/1.json
  def show
    respond_with(@parameter)
  end

  # GET /parameters/new
  def new
    @parameter = Parameter.new

    respond_with(@parameter)
  end

  # GET /parameters/1/edit
  def edit
    respond_with(@parameter)
  end

  # POST /parameters
  # POST /parameters.json
  def create
    @parameter = Parameter.new(parameter_params)

    if @parameter.save
      respond_with(@parameter, location: @parameter, notice: 'Parameter was successfully created.')
    else
      respond_with(@parameter)
    end
  end

  # PATCH/PUT /parameters/1
  # PATCH/PUT /parameters/1.json
  def update
    if @parameter.update(parameter_params)
      respond_with(@parameter, location: @parameter, notice: 'Parameter was successfully updated.')
    else
      respond_with(@parameter)
    end
  end

  # DELETE /parameters/1
  # DELETE /parameters/1.json
  def destroy
    @parameter.destroy

    respond_with(@parameter, location: parameters_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_parameter
    @parameter = Parameter.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def parameter_params
    params.require(:parameter).permit(:name, :type, :rule_id)
  end
end
