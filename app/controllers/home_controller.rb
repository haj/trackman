class HomeController < ApplicationController
  layout 'map'
  include UsersHelper

	def index
		
		if is_manager?(current_user)
			timezone = current_user.time_zone
			Time.use_zone(timezone) do
				@cars = Car.all
				@positions = Car.all_positions(@cars) 
				@markers = Gmaps4rails.build_markers(@positions) do |position, marker|
				  marker.lat position.latitude.to_s
				  marker.lng position.longitude.to_s
				  marker.infowindow "#{position.try(:car).try(:numberplate)}/#{position.try(:car).try(:driver).try(:name)}/#{position.time}"
				end

				gon.watch.data = @markers

				gon.push({
				  :url => "/cars",
				  :map_id => "cars_index",
				  :resource => "cars", 
				  :query_params => request.query_parameters
				})
			end

		elsif is_employee?(current_user) || is_driver?(current_user)
			redirect_to conversations_path 
		else
			redirect_to new_user_session_path
		end
	
	end

	def test
	end

end
