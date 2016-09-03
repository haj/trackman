class WorkSchedulesController < ApplicationController
  # Include module / class
  add_breadcrumb "Work Schedules", :work_schedules_url

  include Batchable
  include Breadcrumbable

  # Callback controller
  before_action :set_work_schedule, only: [:show, :edit, :update, :destroy]

  # GET /work_schedules
  # GET /work_schedules.json
  def index
    @work_schedules = WorkSchedule.page(params[:page])

    respond_with(@work_schedules)
  end

  # GET /work_schedules/1
  # GET /work_schedules/1.json
  def show
    respond_with(@work_schedule)
  end

  def edit
    respond_with(@work_schedule)    
  end

  # GET /work_schedules/new
  def new
    @work_schedule = WorkSchedule.new

    respond_with(@work_schedule)
  end

  # POST /work_schedules
  # POST /work_schedules.json
  def create
    @work_schedule = WorkSchedule.new(work_schedule_params)

    if @work_schedule.save
      flash[:notice] = 'Work Schedule was successfully created !'
      flash.keep(:notice)
      render js: "window.location = '#{work_schedules_path}'"
    else
      render js: "window.location = '#{new_work_schedule_path}'"
    end
  end

  # DELETE /work_schedules/1
  # DELETE /work_schedules/1.json
  def destroy
    @work_schedule.destroy

    respond_with(@work_schedule, location: work_schedules_url, notice: 'Work schedule was successfully destroyed.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work_schedule
    @work_schedule = WorkSchedule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_schedule_params
    params.require(:work_schedule).permit(:car_id, :name, shifts: [:start, :end, :wday])
  end

  def shifts_params
    params.require(:shifts).permit!
  end

end
