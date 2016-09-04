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
    @xml_destination = XmlDestination.new(xml_destination_param)

    @status = 
      if @xml_destination.save
        true
      else
        false
      end

    respond_to :js
  end

  def update
    
  end

  def destroy
    
  end

  private

  def set_order
    @order = Order.find(params[:id])    
  end

  def xml_destination_param
    params.require(:xml_destination).permit(:tmp_attachment_id)
  end
end
