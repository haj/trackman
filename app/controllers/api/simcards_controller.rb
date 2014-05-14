class Api::SimcardsController < ApplicationController
  before_action :set_simcard, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json

  has_scope :by_teleprovider
  has_scope :available do |controller, scope, value|
    if value == "all"
      scope
    elsif value == "true"
      scope.available
    elsif value == "false"
      scope.used
    end 
  end 

  def available
    @simcards = Simcard.available_simcards
  end

  def index
    @simcards = apply_scopes(Simcard).all
  end

  def show
  end

  def new
    @simcard = Simcard.new
  end

  def edit
  end

  def create
    @simcard = Simcard.new(simcard_params)

    respond_to do |format|
      if @simcard.save
        format.html { redirect_to @simcard, notice: 'Simcard was successfully created.' }
        format.json { render action: 'show', status: :created, location: @simcard }
      else
        format.html { render action: 'new' }
        format.json { render json: @simcard.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @simcard.update(simcard_params)
        format.html { redirect_to @simcard, notice: 'Simcard was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @simcard.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @simcard.destroy
    respond_to do |format|
      format.html { redirect_to simcards_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_simcard
      @simcard = Simcard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def simcard_params
      params.require(:simcard).permit(:telephone_number, :teleprovider_id, :monthly_price, :device_id)
    end
end
