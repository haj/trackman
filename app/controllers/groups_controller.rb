class GroupsController < ApplicationController
  before_action :set_group, only: [:edit, :update, :destroy]
  load_and_authorize_resource
  # GET /groups
  # GET /groups.json
  def index
    @q = Group.search(params[:q])
    @groups = @q.result(distinct: true)
    respond_to do |format|
      format.html {render :layout => "index_template"}
    end
  end

  def show
    @group = Group.find(params[:id])
    @alarms = @group.alarms
    @cars = @group.cars

    @positions = Car.all_positions(@cars) 

    @markers = Gmaps4rails.build_markers(@positions) do |position, marker|
      marker.lat position.latitude.to_s
      marker.lng position.longitude.to_s
      marker.infowindow "#{position.car.numberplate}"
    end

    gon.watch.data = @markers

    gon.push({
      :url => "/groups",
      :map_id => "groups_show",
      :resource => "groups", 
      :query_params => request.query_parameters
    })
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  def live
    @group = Group.find(params[:id])
    @cars = @group.cars
    @positions = Car.all_positions(@cars)    
    @hash = Gmaps4rails.build_markers(@positions) do |position, marker|
      marker.lat position[:latitude].to_s
      marker.lng position[:longitude].to_s
    end

    gon.push({
      :data => @hash,
      :url => "/groups/#{@group.id}/live",
      :map_id => "group_cars",
      :resource => "groups"
    })
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end


  def batch_destroy
    group_ids = params[:group_ids]
    group_ids.each do |group_id|
      @group = Group.find(group_id)
      @group.destroy
    end
    redirect_to groups_path
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, group_ids: [])
    end
end
