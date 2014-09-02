class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  # GET /regions
  # GET /regions.json
  def index
    @regions = Region.all
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
    # logger.warn vertices_params
    # render text: vertices_params
    # return

    @region = Region.new(name: region_params['name'])

      if @region.save
        vertices = vertices_params['markers'].values

        vertices.each do |vertex|
          new_vertex = Vertex.create(latitude: vertex['latitude'], longitude: vertex['longitude'], region_id: @region.id)
        end

        flash[:notice] = 'Region was successfully created !'
        flash.keep(:notice)
        render js: "window.location = '#{regions_path}'"
      else
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
      params.require(:vertices).permit!
    end
end
