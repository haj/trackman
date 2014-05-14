class Api::TeleprovidersController < ApplicationController
  before_action :set_teleprovider, only: [:show, :edit, :update, :destroy]
  
  skip_before_filter  :verify_authenticity_token
  #before_filter :restrict_access_for_a_valid_token , :except => [:search]
  respond_to :json

  def index
    @teleproviders = Teleprovider.all
  end

  def show
  end

  def new
    @teleprovider = Teleprovider.new
  end

  def edit
  end

  def create
    @teleprovider = Teleprovider.new(teleprovider_params)

    respond_to do |format|
      if @teleprovider.save
        format.html { redirect_to @teleprovider, notice: 'Teleprovider was successfully created.' }
        format.json { render action: 'show', status: :created, location: @teleprovider }
      else
        format.html { render action: 'new' }
        format.json { render json: @teleprovider.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @teleprovider.update(teleprovider_params)
        format.html { redirect_to @teleprovider, notice: 'Teleprovider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @teleprovider.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @teleprovider.destroy
    respond_to do |format|
      format.html { redirect_to teleproviders_url }
      format.json { head :no_content }
    end
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
