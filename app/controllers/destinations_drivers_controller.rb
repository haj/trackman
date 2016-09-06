class DestinationsDriversController < ApplicationController
  before_action :set_destination
  
  def show
    
  end

  def accept
    @destination.accept
    @destination.save

    respond_with(@destination, location: @destination, notice: 'Success accept order.')
  end

  def decline
    @destination.decline
    @destination.save

    respond_to :js
  end

  private

  def set_destination
    @destination = DestinationsDriver.find(params[:id])
  end
end
