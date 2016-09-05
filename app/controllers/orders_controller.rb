class OrdersController < ApplicationController
  add_breadcrumb "Orders", :orders_url
  include Breadcrumbable

  #Callback
  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.joins(:xml_destination).page(params[:page]).per(30)

    respond_with(@orders)
  end

  def show
    
  end

  def new
    @xml_destination = XmlDestination.new  

    respond_with(@xml_destination)
  end

  def create
    @xml_destination = current_user.xml_destinations.new(xml_destination_param)

    if @xml_destination.save
      respond_with(@xml_destination, location: orders_url, notice: 'Orders successfully created.')
    else
      respond_with(@xml_destination, location: orders_url, error: 'Something went wrong. Please try again or contact developer.')
    end
  end

  def update
    
  end

  def destroy
    
  end

  def parse_xml
    @data            = TmpAttachment.find(xml_destination_param[:tmp_attachment_id]).retrieve_xml
    @xml_destination = XmlDestination.new
    @xml_destination.orders.build

    respond_to :js
  end

  private

  def set_order
    @order = Order.find(params[:id])    
  end

  def xml_destination_param
    params.require(:xml_destination).permit(
      :tmp_attachment_id,
      orders_attributes: [
        :customer_name, :latitude, :longitude, :package, 
        destinations_drivers_attributes: [:user_id]
      ]
    )
  end
end
