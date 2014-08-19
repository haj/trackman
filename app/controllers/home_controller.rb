class HomeController < ApplicationController
  def index
  	if !current_user.nil?
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

	    #@time = Time.zone.now
  	else
  		redirect_to new_user_session_path
  	end
  end

  def test
  end

end
