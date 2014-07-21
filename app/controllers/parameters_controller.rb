class ParametersController < ApplicationController
  before_action :set_parameter, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /parameters
  # GET /parameters.json
  def index
    @parameters = Parameter.all
  end

  # GET /parameters/1
  # GET /parameters/1.json
  def show
  end

  # GET /parameters/new
  def new
    @parameter = Parameter.new
  end

  # GET /parameters/1/edit
  def edit
  end

  # POST /parameters
  # POST /parameters.json
  def create
    @parameter = Parameter.new(parameter_params)

    respond_to do |format|
      if @parameter.save
        format.html { redirect_to @parameter, notice: 'Parameter was successfully created.' }
        format.json { render :show, status: :created, location: @parameter }
      else
        format.html { render :new }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parameters/1
  # PATCH/PUT /parameters/1.json
  def update
    respond_to do |format|
      if @parameter.update(parameter_params)
        format.html { redirect_to @parameter, notice: 'Parameter was successfully updated.' }
        format.json { render :show, status: :ok, location: @parameter }
      else
        format.html { render :edit }
        format.json { render json: @parameter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parameters/1
  # DELETE /parameters/1.json
  def destroy
    @parameter.destroy
    respond_to do |format|
      format.html { redirect_to parameters_url, notice: 'Parameter was successfully destroyed.' }
      format.json { head :no_content }
    end
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
