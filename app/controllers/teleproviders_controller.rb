class TeleprovidersController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_teleprovider, only: [:show, :edit, :update, :destroy]
  
  # GET /teleproviders
  # GET /teleproviders.json
  def index
    @q = Teleprovider.search(params[:q])
    @teleproviders = @q.result(distinct: true).page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /teleproviders/1
  # GET /teleproviders/1.json
  def show
    respond_with(@teleprovider)
  end

  # GET /teleproviders/new
  def new
    @teleprovider = Teleprovider.new

    respond_with(@teleprovider)
  end

  # GET /teleproviders/1/edit
  def edit
    respond_with(@teleprovider)
  end

  # POST /teleproviders
  # POST /teleproviders.json
  def create
    @teleprovider = Teleprovider.new(teleprovider_params)

    if @teleprovider.save
      respond_with(@teleprovider, location: teleproviders_url, notice: 'Teleprovider was successfully created.')
    else
      respond_with(@teleprovider)
    end
  end

  # PATCH/PUT /teleproviders/1
  # PATCH/PUT /teleproviders/1.json
  def update
    if @teleprovider.update(teleprovider_params)
      respond_with(@teleprovider, location: teleproviders_url, notice: 'Teleprovider was successfully updated.')
    else
      respond_with(@teleprovider)
    end
  end

  # DELETE /teleproviders/1
  # DELETE /teleproviders/1.json
  def destroy
    @teleprovider.destroy

    respond_with(@teleprovider, location: teleproviders_url)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_teleprovider
    @teleprovider = Teleprovider.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def teleprovider_params
    params.require(:teleprovider).permit(:name, :apn)
  end
end
