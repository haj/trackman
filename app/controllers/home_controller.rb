class HomeController < ApplicationController
  def index
  	if !current_user.nil?
	    @cars = Car.all
	    @positions = Car.all_positions(@cars)  
	    @hash = Gmaps4rails.build_markers(@positions) do |position, marker|
	      marker.lat position[:latitude].to_s
	      marker.lng position[:longitude].to_s
	      marker.infowindow "Vehicle"
	    end

	    gon.watch.data = @hash

	    gon.push({
	      :url => "/cars",
	      :map_id => "cars_index",
	      :resource => "cars", 
	      :query_params => request.query_parameters
	    })

	    @time = Time.zone.now
  	else
  		redirect_to new_user_session_path
  	end
  end
end
