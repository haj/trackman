class HomeController < ApplicationController
  # layout 'map'
  include UsersHelper
  include ApplicationHelper
  before_filter :set_settings, only: :index

  def index
    if is_manager?(current_user)

    elsif is_employee?(current_user) || is_driver?(current_user)
      redirect_to conversations_path
    else
      redirect_to new_user_session_path
    end
  end

  def cars_overview
    # @cars = nil
    @cars = Car.all.includes(:device).includes(:car_type)
  end

  def logbook_data
    # raise params.inspect
    car_id = params[:car_id]
    @car = Car.find(params[:car_id])

    if @car.last_position
      @dates = [Settings.start_date, Settings.end_date]

      @array_dates = dates_in_range Settings.start_date, Settings.end_date

      last_day = @car.last_position.time.to_date
      and_before = last_day.yesterday

      @array_dates = dates_in_range and_before, last_day

      # if Rails.env.development?
      #   d = DateTime.now.change({ month: 11, day: 06, year: 2015}).to_date
      #   e = DateTime.now.change({ month: 11, day: 10, year: 2015}).to_date
      #   if @car.device.id == 13
      #     @array_dates = dates_in_range DateTime.now.yesterday.to_date, DateTime.now.to_date
      #   else
      #     @array_dates = dates_in_range d, e
      #   end
      # end

      logger.warn "Ready to load Data for logbook_data"
      # @data = @car.locations_grouped_by_these_dates [Date.today]
      @data = Car.locations_grouped_by_these_dates(@array_dates, @car.id)

      logger.warn "Logbook is rendered for : "
      logger.warn @array_dates
    end
  end

  def notifications
    @notifications = PublicActivity::Activity.order("created_at desc")
    logger.warn @notifications.inspect
    render json: @notifications
  end

  def set_minimum_parking_time
    if params["mpt"] != ""
      if params["mpt"].to_i >= 1 and params["mpt"].to_i <= 15
        Settings.minimum_parking_time = params["mpt"]
      end
    end
    redirect_to :back
  end

  def update_time_log
    current_user.update(time_log: params[:user][:time_log])
    redirect_to :back
  end

  def apply_filter
    Settings.start_date = params[:start_date].to_date
    Settings.end_date = params[:end_date].to_date
    Settings.start_time = params[:start_time]
    Settings.end_time = params[:end_time]
    render :text => 'OK'
  end

  def set_settings
    Settings.start_date = DateTime.yesterday.to_date
    Settings.start_time = "05:00"
    Settings.end_date = DateTime.now.to_date
    Settings.end_time = DateTime.now.strftime("%H:%M")
  end
end
