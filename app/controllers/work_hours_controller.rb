class WorkHoursController < ApplicationController
  # Include module / class
  load_and_authorize_resource

  # Callback controller
  before_action :set_work_hour, only: [:show, :edit, :update, :destroy]
  
  # GET /work_hours
  # GET /work_hours.json
  def index
    @work_hours = WorkHour.all

    respond_with(@work_hours)
  end

  # GET /work_hours/1
  # GET /work_hours/1.json
  def show
    respond_with(@work_hour)
  end

  # GET /work_hours/new
  def new
    @work_hour = WorkHour.new

    respond_with(@work_hour)
  end

  # GET /work_hours/1/edit
  def edit
    respond_with(@work_hour)
  end

  # POST /work_hours
  # POST /work_hours.json
  def create
    @work_hour = WorkHour.new(work_hour_params)

    if @work_hour.save
      respond_with(@work_hour, location: work_hours_url, notice: 'Work hour was successfully created.')
    else
      respond_with(@work_hour)
    end
  end

  # PATCH/PUT /work_hours/1
  # PATCH/PUT /work_hours/1.json
  def update
    if @work_hour.update(work_hour_params)
      respond_with(@work_hour, location: work_hours_url, notice: 'Work hour was successfully updated.')
    else
      respond_with(@work_hour)
    end
  end

  # DELETE /work_hours/1
  # DELETE /work_hours/1.json
  def destroy
    @work_hour.destroy

    respond_with(@work_hour, location: work_hours_url, notice: 'Work hour was successfully destroyed.')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work_hour
    @work_hour = WorkHour.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_hour_params
    params.require(:work_hour).permit(:day_of_week, :starts_at, :ends_at, :device_id)
  end
end
