class WorkScheduleGroupsController < ApplicationController
  # Include module / class
  include Batchable

  # Callback controller
  before_action :set_work_schedule_group, only: [:show, :edit, :update, :destroy]

  # GET /work_schedule_groups
  # GET /work_schedule_groups.json
  def index
    @work_schedule_groups = WorkScheduleGroup.all
    respond_to do |format|
      format.html {render :layout => "index_template"}
    end
  end

  # GET /work_schedule_groups/1
  # GET /work_schedule_groups/1.json
  def show
    respond_with(@work_schedule_group)
  end

  # GET /work_schedule_groups/new
  def new
    @work_schedule_group = WorkScheduleGroup.new

    respond_with(@work_schedule_group)
  end

  # GET /work_schedule_groups/1/edit
  def edit
    respond_with(@work_schedule_group)
  end

  # POST /work_schedule_groups
  # POST /work_schedule_groups.json
  def create
    @work_schedule_group = WorkScheduleGroup.new(work_schedule_group_params)

    if @work_schedule_group.save
      respond_with(@work_schedule_group, location: @work_schedule_group, notice: 'Work schedule group was successfully created.')
    else
      respond_with(@work_schedule_group)
    end
  end

  # PATCH/PUT /work_schedule_groups/1
  # PATCH/PUT /work_schedule_groups/1.json
  def update
    if @work_schedule_group.update(work_schedule_group_params)
      respond_with(@work_schedule_group, location: @work_schedule_group, notice: 'Work schedule group was successfully updated.')
    else
      respond_with(@work_schedule_group)
    end
  end

  # DELETE /work_schedule_groups/1
  # DELETE /work_schedule_groups/1.json
  def destroy
    @work_schedule_group.destroy

    respond_with(@work_schedule_group, location: work_schedule_groups_url, notice: 'Work schedule group was successfully destroyed.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work_schedule_group
    @work_schedule_group = WorkScheduleGroup.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_schedule_group_params
    params.require(:work_schedule_group).permit(:name )
  end
end
