class HomeController < ApplicationController
  # layout 'map'
  include UsersHelper
  include ApplicationHelper
  before_filter :set_settings, only: :index

	def cars_overview
		# @cars = nil
		@cars = Car.all.includes(:device).includes(:car_type)
	end

	def logbook_data
		# raise params.inspect
		car_id = params[:car_id]
		@car = Car.find(params[:car_id])

		unless @car.last_position.nil?
			@dates = [Settings.start_date, Settings.end_date]

			@array_dates = dates_in_range Settings.start_date, Settings.end_date

			if Rails.env.development?
				d = DateTime.now.change({ month: 12, day: 17, year: 2015}).to_date
				p d.to_date
				p d.tomorrow.tomorrow.tomorrow.tomorrow.to_date
				@array_dates = dates_in_range d, d.tomorrow
			end

			@data = @car.locations_grouped_by_these_dates @array_dates

			logger.warn "Logbook is rendered for : "
			logger.warn @array_dates
		end
	end

	def all_cars
			Time.use_zone(timezone) do
				@cars = Car.all.includes(:device)

				@positions = Car.all_positions(@cars)

				@markers = Gmaps4rails.build_markers(@positions) do |position, marker|
				  marker.lat position.latitude.to_s
				  marker.lng position.longitude.to_s
				  # driver = position.try(:car).try(:driver).try(:name)
				  # driver = "Unknown" if driver == ""
				  # marker.infowindow "#{position.try(:car).try(:name)}/
				  # #{position.try(:car).try(:numberplate)}/
				  # #{driver}/
				  # #{position.try(:time)}/
				  # #{position.try(:address)}/"
				end

				gon.watch.all_cars = @markers

				gon.push({
				  :url => "/cars",
				  :map_id => "cars_index",
				  :resource => "cars",
				  :query_params => request.query_parameters
				})
			end
	end

	def index

		if is_manager?(current_user)
			timezone = current_user.time_zone
			Time.use_zone(timezone) do
				@cars = Car.all.includes(:device)

				@positions = Car.all_positions(@cars)

				@markers = Gmaps4rails.build_markers(@positions) do |position, marker|
				  marker.lat position.latitude.to_s
				  marker.lng position.longitude.to_s
				  driver = position.try(:car).try(:driver).try(:name)
				  driver = "Unknown" if driver == ""
				  marker.infowindow "#{position.try(:car).try(:name)}/
				  #{position.try(:car).try(:numberplate)}/
				  #{driver}/
				  #{position.try(:time)}/
				  #{position.try(:address)}/"
				end

				# gon.watch.all_cars = @markers

				# gon.push({
				#   :url => "/cars",
				#   :map_id => "cars_index",
				#   :resource => "cars",
				#   :query_params => request.query_parameters
				# })
			end
		elsif is_employee?(current_user) || is_driver?(current_user)
			redirect_to conversations_path
		else
			redirect_to new_user_session_path
		end
	end

	def one_car_render_pin
		timezone = current_user.time_zone.to_s

		Time.use_zone(timezone) do
			car_id = params[:car_id]
			@car = Car.find(car_id)

			@position = Car.one_car_position(@car)

			@markers = Gmaps4rails.build_markers(@position) do |position, marker|
			  marker.lat position.latitude.to_s
			  marker.lng position.longitude.to_s
			  driver = position.try(:car).try(:driver).try(:name)
			  driver = "Unknown" if driver == ""
			  marker.infowindow "#{position.try(:car).try(:name)}/
			  #{position.try(:car).try(:numberplate)}/
			  #{driver}/
			  #{position.try(:time)}/
			  #{position.try(:address)}/"
			end

			gon.watch.pin = @markers

			gon.push({
			  :url => "/cars",
			  :map_id => "cars_index",
			  :resource => "cars"
			})

		end

	end

	def one_car_render_directions

	    # @alarms = @car.alarms
	    date = params[:date].to_date
	    car_id = params[:car_id]
	    @car = Car.find(car_id)
		  timezone = current_user.time_zone.to_s

		Time.use_zone(timezone) do
			@date = {start_date: date.to_date, start_time: "00:00", end_date: date.to_date, end_time: "23:59"}
			@positions = @car.positions_with_dates(@date, timezone)

			@markers = Gmaps4rails.build_markers(@position) do |position, marker|
		      marker.lat position.latitude.to_s
		      marker.lng position.longitude.to_s
			  driver = position.try(:car).try(:driver).try(:name)
			  driver = "Unknown" if driver == ""
			  marker.infowindow "#{position.time.to_s}/
		      #{position.status}/
		      #{position.try(:car).try(:name)}/
			  #{position.try(:car).try(:numberplate)}/
			  #{driver}/
			  #{position.try(:time)}/
			  #{position.try(:address)}/"
			end

			@markers = Location.markers(@positions)

			gon.watch.road = @markers

			gon.push({
			  # :url => "/cars",
			  :map_id => "cars_index"
			  # :resource => "cars"
			})
		end

	end

	def logbook_render
		car_id = params[:car_id]

		@dates = {start_date: Settings.start_date, start_time: Settings.start_time,
			end_date: Settings.end_date, end_time: Settings.end_time}

		@car = Car.find(car_id)

		# @dates[:start_date] = "2015-08-05".to_date
		# @dates[:end_date] = "2015-08-10".to_date

		@logbook_data = []

		@logbook_data = @car.positions_with_dates(@dates, "UTC")

		while @logbook_data.empty? or @logbook_data == nil
			@logbook_data = @car.positions_with_dates(@dates, "UTC")
			if @logbook_data.empty? or @logbook_data == nil
				@dates[:start_date] = @dates[:start_date].yesterday
				@dates[:end_date] = @dates[:end_date].yesterday
			end
		end

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
















