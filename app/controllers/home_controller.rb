class HomeController < ApplicationController
  def index
  	if !current_user.nil?

  	else
  		redirect_to new_user_session_path
  	end
  end
end
