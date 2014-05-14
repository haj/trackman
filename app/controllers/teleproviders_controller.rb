class TeleprovidersController < ApplicationController
  before_action :set_teleprovider, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  # GET /teleproviders
  # GET /teleproviders.json
  def index
    @q = Teleprovider.search(params[:q])
    @teleproviders = @q.result(distinct: true)
  end

  # GET /teleproviders/1
  # GET /teleproviders/1.json
  def show
  end

  # GET /teleproviders/new
  def new
    @teleprovider = Teleprovider.new
  end

  # GET /teleproviders/1/edit
  def edit
  end

  # POST /teleproviders
  # POST /teleproviders.json
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

  # PATCH/PUT /teleproviders/1
  # PATCH/PUT /teleproviders/1.json
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

  # DELETE /teleproviders/1
  # DELETE /teleproviders/1.json
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
