class WorkSchedulesController < ApplicationController
  before_action :set_work_schedule, only: [:show, :edit, :update, :destroy]

  # GET /work_schedules
  # GET /work_schedules.json
  def index
    @work_schedules = WorkSchedule.all
  end

  # GET /work_schedules/1
  # GET /work_schedules/1.json
  def show
  end

  # GET /work_schedules/new
  def new
    @work_schedule = WorkSchedule.new
  end

  # GET /work_schedules/1/edit
  def edit
  end

  # POST /work_schedules
  # POST /work_schedules.json
  def create

    @work_schedule = WorkSchedule.new(work_schedule_params)

    respond_to do |format|
      if @work_schedule.save

        shifts_params.values.each do |shift| 
          start_time = shift['start'].to_time
          end_time = shift['end'].to_time
          wday_index = shift['wday']
          new_work_hour = WorkHour.create(starts_at: start_time , ends_at: end_time , day_of_week: wday_index)
          @work_schedule.work_hours << new_work_hour
        end

        format.html { redirect_to @work_schedule, notice: 'Work schedule was successfully created.' }
        format.json { render :show, status: :created, location: @work_schedule }
      else
        format.html { render :new }
        format.json { render json: @work_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /work_schedules/1
  # PATCH/PUT /work_schedules/1.json
  def update
    respond_to do |format|
      if @work_schedule.update(work_schedule_params)
        format.html { redirect_to @work_schedule, notice: 'Work schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @work_schedule }
      else
        format.html { render :edit }
        format.json { render json: @work_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /work_schedules/1
  # DELETE /work_schedules/1.json
  def destroy
    @work_schedule.destroy
    respond_to do |format|
      format.html { redirect_to work_schedules_url, notice: 'Work schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_work_schedule
      @work_schedule = WorkSchedule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def work_schedule_params
      params.require(:work_schedule).permit(:car_id, :name)
    end

    def shifts_params
      params.require(:shifts).permit!
    end

end
