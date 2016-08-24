class RegionsController < ApplicationController
  # Include module / class
  include Batchable
  load_and_authorize_resource

  # Callback controller
  before_action :set_region, only: [:show, :edit, :update, :destroy]


  def index
    @regions = Region.page(params[:page])

    respond_with(@regions)
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
    respond_with(@region)
  end

  # GET /regions/new
  def new
    @region = Region.new

    respond_with(@region)
  end

  # GET /regions/1/edit
  def edit
    respond_with(@region)
  end

  # POST /regions
  # POST /regions.json
  def create
    @region = Region.new(region_params)
    
    if @region.save
      flash[:notice] = 'Region was successfully created !'
      flash.keep(:notice)
      render js: "window.location = '#{regions_path}'"
    else
      flash[:alert] = "Please enter a name for your region and select a region (using the map below)"
      render js: "window.location = '#{new_region_path}'"
    end
  end

  # PATCH/PUT /regions/1
  # PATCH/PUT /regions/1.json
  def update
    if @region.update(region_params)
      flash[:notice] = 'Region was successfully updated !'
      flash.keep(:notice)
      render js: "window.location = '#{regions_path}'"
    else
      flash[:alert] = "Please enter a name for your region and select a region (using the map below)"
      render js: "window.location = '#{new_region_path}'"
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    @region.destroy

    respond_with(@region, location: regions_url, notice: 'Region was successfully destroyed.')
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_region
    @region = Region.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def region_params
    params.require(:region).permit(:name, vertices: { markers: [ :latitude, :longitude ] })
  end

end
