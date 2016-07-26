class RegionsController < ApplicationController
  include Batchable

  before_action :set_region, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @regions = Region.all
    respond_to do |format|
      format.html
    end
  end

  # GET /regions/1
  # GET /regions/1.json
  def show
  end

  # GET /regions/new
  def new
    @region = Region.new
  end

  # GET /regions/1/edit
  def edit
  end

  # POST /regions
  # POST /regions.json
  def create
    @region = Region.new(name: region_params['name'])
    
    vertices = vertices_params['vertices']
    markers = vertices['markers'] if !vertices.nil? && vertices.include?('markers')

    if @region.save && !markers.nil?

      unless markers.nil? 
        vertices = markers.try(:values)
        vertices.each do |vertex|
          new_vertex = Vertex.create(latitude: vertex['latitude'], longitude: vertex['longitude'], region_id: @region.id)
        end
      end

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
    respond_to do |format|
      if @region.update(region_params)
        format.html { redirect_to @region, notice: 'Region was successfully updated.' }
        format.json { render :show, status: :ok, location: @region }
      else
        format.html { render :edit }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /regions/1
  # DELETE /regions/1.json
  def destroy
    @region.destroy
    respond_to do |format|
      format.html { redirect_to regions_url, notice: 'Region was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_region
      @region = Region.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def region_params
      params.require(:region).permit(:name)
    end

    def vertices_params
      params.permit!
    end
end
