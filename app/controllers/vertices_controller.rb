class VerticesController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_vertex, only: [:show, :edit, :update, :destroy]
  
  # GET /vertices
  # GET /vertices.json
  def index
    @vertices = Vertex.all

    respond_with(@vertices)
  end

  # GET /vertices/1
  # GET /vertices/1.json
  def show
    respond_with(@vertice)
  end

  # GET /vertices/new
  def new
    @vertex = Vertex.new

    respond_with(@vertice)
  end

  # GET /vertices/1/edit
  def edit
    respond_with(@vertice)
  end

  # POST /vertices
  # POST /vertices.json
  def create
    @vertex = Vertex.new(vertex_params)

    if @vertex.save
      respond_with(@vertex, location: vertices_url, notice: 'Vertex was successfully created.')
    else
      respond_with(@vertex)
    end
  end

  # PATCH/PUT /vertices/1
  # PATCH/PUT /vertices/1.json
  def update
    if @vertex.update(vertex_params)
      respond_with(@vertex, location: vertices_url, notice: 'Vertex was successfully updated.')
    else
      respond_with(@vertex)
    end
  end

  # DELETE /vertices/1
  # DELETE /vertices/1.json
  def destroy
    @vertex.destroy

    respond_with(@vertex, location: vertices_url, notice: 'Vertex was successfully destroyed.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_vertex
    @vertex = Vertex.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def vertex_params
    params.require(:vertex).permit(:latitude, :longitude, :region_id)
  end
end
