class ReportingController < ApplicationController
  include QueryReportHelper
  # include QueryReport::Helper
  # include QueryReportLinkHelper

  add_breadcrumb "Report", :reports_url

  def index
    reporter(User.where(nil), custom_view: true, template_class: PdfReportTemplate) do
      filter :email, type: :text
      filter :first_name, type: :text
      filter :last_name, type: :text
      filter :created_at, type: :date

      column :email
      column :first_name
      column :last_name
      column :created_at
    end
  end

  def devices
    add_breadcrumb "Devices"

    reporter(Device.where(nil).includes(:device_type, :device_model), custom_view: true, template_class: PdfReportDevicesTemplate) do
      filter :name, type: :text
      filter :emei, type: :text
      filter :device_type, type: :text
      filter :device_model, type: :text

      column :name
      column :emei
      column :device_type do |d|
        link_to d.device_type.name, d
      end
      column :device_model do |d|
        link_to d.device_model.name, d
      end
    end
  end

  def simcards
    add_breadcrumb "Sim Cards"

    reporter(Simcard.where(nil), custom_view: true, template_class: PdfReportSimcardsTemplate) do
      filter :telephone_number, type: :text
      filter :teleprovider, type: :text

      column :telephone_number
      column :teleprovider do |d|
        link_to d.teleprovider.name, d
      end
    end
  end

  def vehicles
    add_breadcrumb "Vehicles"

    reporter(Car.where(nil).includes(:car_model, :car_type), custom_view: true, template_class: PdfReportVehiclesTemplate) do
      filter :mileage, type: :text
      filter :numberplate, type: :text
      filter :car_type, type: :text
      filter :car_model, type: :text

      column :mileage
      column :numberplate
      column :car_type do |c|
        link_to c.car_type.try(:name), c
      end
      column :car_model do |c|
        link_to c.car_model.try(:name), c
      end
    end
  end

  def users
    add_breadcrumb "Users"
    
    reporter(User.where(nil), custom_view: true, template_class: PdfReportUsersTemplate) do
      filter :email, type: :text
      filter :first_name, type: :text
      filter :last_name, type: :text
      filter :created_at, type: :date

      column :email
      column :first_name
      column :last_name
      column :created_at
    end
  end

  def regions
    
  end

  def alarms
    
  end
end