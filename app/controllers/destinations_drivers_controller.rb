class DestinationsDriversController < ApplicationController
  before_action :set_destination, except: :create
  
  def show
    
  end

  def create
    @destination = DestinationsDriver.new(destinations_driver_params)

    if @destination.save
      respond_with(@destination, location: order_path(@destination.order), notice: 'Success assign another driver')
    else
      respond_with(@destination, location: order_path(@destination.order), error: 'Failed assign another driver')
    end
  end

  def accept
    @destination.accept
    @destination.save

    respond_with(@destination, location: @destination.order, notice: 'Success accept order.')
  end

  def decline
    declined_order = DeclinedOrder.new(decline_params)

    declined_order.save

    respond_with(declined_order, location: request.referer, notice: 'Success decline order.')
  end

  private

  def set_destination
    @destination = DestinationsDriver.find(params[:id])
  end

  def decline_params
    params[:declined_order][:destinations_driver_id] = @destination.id

    params.require(:declined_order).permit(:reason, :destinations_driver_id, :notif_id)
  end

  def destinations_driver_params
    params.require(:destinations_driver).permit(:user_id, :order_id)
  end
end
