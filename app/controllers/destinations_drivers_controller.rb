class DestinationsDriversController < ApplicationController
  before_action :set_destination, except: :create
  before_action :decline_cancel, only: [:decline, :cancel]

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
    respond_with(@declined_order, location: request.referer, notice: 'Success decline order.')
  end

  def finish
    @destination.finish
    @destination.save

    respond_to :js
  end

  def cancel
    respond_with(@declined_order, location: request.referer, notice: 'Success cancel order.')
  end

  private

  def decline_cancel
    @declined_order = DeclinedOrder.new(decline_params)
    @declined_order.save
  end

  def set_destination
    @destination = DestinationsDriver.find(params[:id])
  end

  def decline_params
    params[:declined_order][:destinations_driver_id] = @destination.id
    params[:declined_order][:status] = 
      if @destination.accepted?
        'cancel'
      else
        'decline'
      end

    params.require(:declined_order).permit(:reason, :destinations_driver_id, :notif_id, :status)
  end

  def destinations_driver_params
    params.require(:destinations_driver).permit(:user_id, :order_id)
  end
end
