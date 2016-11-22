module DeviceManufacturersHelper
  def all_device_manufacturers
    DeviceManufacturer.all.collect {|a| [ a.name, a.id ] }
  end
end
