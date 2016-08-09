class GroupsController < ApplicationController
  # Include module / class
  include Batchable
  load_and_authorize_resource
  
  # Callback controller
  before_action :set_group, only: [:show, :edit, :update, :destroy, :live]
  before_action :set_collection, only: [:show, :live]

  # GET /groups
  # GET /groups.json
  def index
    @q = Group.search(params[:q])
    @groups = @q.result(distinct: true)

    respond_with(@groups)
  end

  # GET /group/:id || group_path(:id)
  # Show specific group
  def show
    @alarms = @group.alarms

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

    respond_with(@group)
  end

  # GET /groups/new
  def new
    @group = Group.new

    respond_with(@group)
  end

  # GET /groups/1/edit
  def edit
    respond_with(@group)
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    if @group.save
      respond_with(@group, location: @group, notice: 'Group was successfully created.')
    else
      respond_with(@group)
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    if @group.update(group_params)
      respond_with(@group, location: @group, notice: 'Group was successfully updated.')
    else
      respond_with(@group)
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy

    respond_with(@group, location: groups_url)
  end

  # GET /groups/:id/live || live_group_path(:id)
  # Show live position of car
  def live
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

  private

  # Set collection
  def set_collection
    @cars      = @group.cars
    @positions = Car.all_positions(@cars)        
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def group_params
    params.require(:group).permit(:name, group_ids: [])
  end
end
