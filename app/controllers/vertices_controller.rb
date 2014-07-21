class VerticesController < ApplicationController
  before_action :set_vertex, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  # GET /vertices
  # GET /vertices.json
  def index
    @vertices = Vertex.all
  end

  # GET /vertices/1
  # GET /vertices/1.json
  def show
  end

  # GET /vertices/new
  def new
    @vertex = Vertex.new
  end

  # GET /vertices/1/edit
  def edit
  end

  # POST /vertices
  # POST /vertices.json
  def create
    @vertex = Vertex.new(vertex_params)

    respond_to do |format|
      if @vertex.save
        format.html { redirect_to @vertex, notice: 'Vertex was successfully created.' }
        format.json { render :show, status: :created, location: @vertex }
      else
        format.html { render :new }
        format.json { render json: @vertex.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vertices/1
  # PATCH/PUT /vertices/1.json
  def update
    respond_to do |format|
      if @vertex.update(vertex_params)
        format.html { redirect_to @vertex, notice: 'Vertex was successfully updated.' }
        format.json { render :show, status: :ok, location: @vertex }
      else
        format.html { render :edit }
        format.json { render json: @vertex.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vertices/1
  # DELETE /vertices/1.json
  def destroy
    @vertex.destroy
    respond_to do |format|
      format.html { redirect_to vertices_url, notice: 'Vertex was successfully destroyed.' }
      format.json { head :no_content }
    end
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
