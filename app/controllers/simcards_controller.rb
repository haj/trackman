class SimcardsController < ApplicationController
  # Include module / class
  include Batchable

  load_and_authorize_resource

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

  # Callback controller
  before_action :set_simcard, only: [:show, :edit, :update, :destroy]


  def index
    @q        = apply_scopes(Simcard).all.search(params[:q])
    @simcards = @q.result(distinct: true)

    respond_with(@simcards)
  end

  # GET /simcards/1
  # GET /simcards/1.json
  def show
    respond_with(@simcard)
  end

  # GET /simcards/new
  def new
    @simcard = Simcard.new

    respond_with(@simcard)
  end

  # GET /simcards/1/edit
  def edit
    respond_with(@simcard)
  end

  # POST /simcards
  # POST /simcards.json
  def create
    @simcard = Simcard.new(simcard_params)

    if @simcard.save
      respond_with(@simcard, location: simcards_url, notice: 'Simcard was successfully created.')
    else
      respond_with(@simcard)
    end
  end

  # PATCH/PUT /simcards/1
  # PATCH/PUT /simcards/1.json
  def update
    if @simcard.update(simcard_params)
      respond_with(@simcard, location: simcards_url, notice: 'Simcard was successfully updated')
    else
      respond_with(@simcard)
    end
  end

  # DELETE /simcards/1
  # DELETE /simcards/1.json
  def destroy
    @simcard.destroy

    respond_with(@simcard, location: simcards_url, notice: 'Simcard was successfully deleted')
  end

  # UNUSED METHOD
  def available
    @simcards = Simcard.available_simcards
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_simcard
    @simcard = Simcard.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def simcard_params
    params.require(:simcard).permit(:name, :telephone_number, :teleprovider_id, :monthly_price, :device_id)
  end
end
