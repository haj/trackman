class HomeController < ApplicationController
  # Include module / class
  include UsersHelper
  include ApplicationHelper

  # Callback controller
  before_filter :set_settings, only: :index

  add_breadcrumb "Home", :root_url

  # GET /home || home_index_path
  # If haven't login; redirect to session path
  # If login as employee or driver; redirect to conversations path
  # If manager; Stays at page
  def index    
    if is_manager?(current_user)
      respond_with(current_user)
    elsif is_employee?(current_user) || is_driver?(current_user)
      redirect_to conversations_path
    else
      redirect_to new_user_session_path
    end
  end

  # GET /home/cars_overview || cars_overview_home_index_path
  # Overview all cars; included device
  def cars_overview
    @cars = Car.all.includes(:device).includes(:car_type)
  end

  # GET /logbook_render || logbook_render_path || Render JSON
  # Return log book of a car within 1 day.
  def logbook_data
    @car = Car.find(params[:car_id])

    if @car.last_position
      @date          = params[:date].present? ? params[:date].to_time.to_date : @car.last_position.time.to_date
      @data          = Car.locations_grouped_by_these_dates(@date, @car.id)
    end

    respond_to :json
  end

  # POST /set_minimum_parking_time || set_minimum_parking_time_path
  # Set minimum parking time
  def set_minimum_parking_time
    if params["mpt"] != ""
      if params["mpt"].to_i >= 1 and params["mpt"].to_i <= 15
        Settings.minimum_parking_time = params["mpt"]
      end
    end

    respond_with(current_user, location: :back)
  end

  # PUT  /home/update_time_log || update_time_log_home_index_path
  # Update time log; This will be used as first time from parking time on new day
  def update_time_log
    current_user.update(time_log: params[:user][:time_log])

    respond_with(current_user, location: :back)
  end

  # GET /apply_filter || apply_filter_path
  # Apply filter setting for start date; end date; start time; end time
  def apply_filter
    Settings.start_date = params[:start_date].to_date
    Settings.end_date = params[:end_date].to_date
    Settings.start_time = params[:start_time]
    Settings.end_time = params[:end_time]

    render :text => 'OK'
  end

  # UNUSED METHOD
  def notifications
    @notifications = PublicActivity::Activity.order("created_at desc")
    logger.warn @notifications.inspect
    render json: @notifications
  end

  def set_settings
    Settings.start_date = DateTime.yesterday.to_date
    Settings.start_time = "05:00"
    Settings.end_date = DateTime.now.to_date
    Settings.end_time = DateTime.now.strftime("%H:%M")
  end
end
