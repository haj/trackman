class DestinationsDriversController < ApplicationController
  before_action :set_xml_destination, only: :create

  def create
    @xml_destination.update(destination_params)

    respond_with(@xml_destination, location: orders_path)
  end

  private

  def destination_params
    params.require(:xml_destination).permit(
      :id, orders_attributes: [
        :id, destinations_drivers_attributes: [:user_id]
      ]
    )
  end

  def set_xml_destination
    @xml_destination = XmlDestination.find(params[:xml_destination][:id])
  end
end
