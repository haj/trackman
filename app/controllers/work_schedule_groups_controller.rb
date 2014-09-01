class WorkScheduleGroupsController < ApplicationController
  before_action :set_work_schedule_group, only: [:show, :edit, :update, :destroy]

  # GET /work_schedule_groups
  # GET /work_schedule_groups.json
  def index
    @work_schedule_groups = WorkScheduleGroup.all
  end

  # GET /work_schedule_groups/1
  # GET /work_schedule_groups/1.json
  def show
  end

  # GET /work_schedule_groups/new
  def new
    @work_schedule_group = WorkScheduleGroup.new
  end

  # GET /work_schedule_groups/1/edit
  def edit
  end

  # POST /work_schedule_groups
  # POST /work_schedule_groups.json
  def create
    @work_schedule_group = WorkScheduleGroup.new(work_schedule_group_params)

    respond_to do |format|
      if @work_schedule_group.save
        format.html { redirect_to @work_schedule_group, notice: 'Work schedule group was successfully created.' }
        format.json { render :show, status: :created, location: @work_schedule_group }
      else
        format.html { render :new }
        format.json { render json: @work_schedule_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_schedule_groups/1
  # PATCH/PUT /work_schedule_groups/1.json
  def update
    respond_to do |format|
      if @work_schedule_group.update(work_schedule_group_params)
        format.html { redirect_to @work_schedule_group, notice: 'Work schedule group was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_schedule_group }
      else
        format.html { render :edit }
        format.json { render json: @work_schedule_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_schedule_groups/1
  # DELETE /work_schedule_groups/1.json
  def destroy
    @work_schedule_group.destroy
    respond_to do |format|
      format.html { redirect_to work_schedule_groups_url, notice: 'Work schedule group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_schedule_group
      @work_schedule_group = WorkScheduleGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_schedule_group_params
      params.require(:work_schedule_group).permit(:company_id, :work_schedule_id)
    end
end
