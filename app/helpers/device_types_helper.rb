module DeviceTypesHelper
  def all_device_types
    DeviceType.all.collect {|a| [ a.name, a.id ] }
  end
end
