class FeaturesController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_feature, only: [:show, :edit, :update, :destroy]


  # GET /features
  # GET /features.json
  def index
    @features = Feature.page(params[:page])

    respond_with(@features)
  end

  # GET /features/1
  # GET /features/1.json
  def show
    respond_with(@feature)
  end

  # GET /features/new
  def new
    @feature = Feature.new

    respond_with(@feature)
  end

  # GET /features/1/edit
  def edit
    respond_with(@feature)
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.new(feature_params)

    if @feature.save
      respond_with(@feature, location: features_url, notice: 'Feature was successfully created.')
    else
      respond_with(@feature)
    end
  end

  # PATCH/PUT /features/1
  # PATCH/PUT /features/1.json
  def update
    if @feature.update(feature_params)
      respond_with(@feature, location: features_url, notice: 'Feature was successfully updated.')
    else
      respond_with(@feature)
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature.destroy
    respond_with(@feature, location: features_url, notice: 'Feature was successfully destroyed.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_feature
    @feature = Feature.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feature_params
    params.require(:feature).permit(:name, :role)
  end
end
