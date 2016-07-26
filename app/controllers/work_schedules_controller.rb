class WorkSchedulesController < ApplicationController
  include Batchable

  before_action :set_work_schedule, only: [:show, :edit, :update, :destroy]
  #load_and_authorize_resource  

  # GET /work_schedules
  # GET /work_schedules.json
  def index
    @work_schedules = WorkSchedule.all
    respond_to do |format|
      format.html
    end
  end

  # GET /work_schedules/1
  # GET /work_schedules/1.json
  def show
  end

  # GET /work_schedules/new
  def new
    @work_schedule = WorkSchedule.new
  end


  # POST /work_schedules
  # POST /work_schedules.json
  def create
    @work_schedule = WorkSchedule.new(work_schedule_params)
      if @work_schedule.save

        shifts_params.values.each do |shift| 
          start_time = shift['start'].to_time
          end_time = shift['end'].to_time
          wday_index = shift['wday']
          if end_time.hour == 0 && end_time.min == 0
            new_work_hour = WorkHour.create(starts_at: start_time.to_s(:db) , ends_at: Time.parse("23:59").to_s(:db) , day_of_week: wday_index)
          else
            new_work_hour = WorkHour.create(starts_at: start_time.to_s(:db) , ends_at: end_time.to_s(:db) , day_of_week: wday_index)
          end
          @work_schedule.work_hours << new_work_hour
        end

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
