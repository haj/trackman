module CarsHelper
  def no_available_devices?
    Device.available_devices.count == 0
  end

  def list_available_devices
    select_tag('car[device_id]', content_tag(:option,'Select Device ...', :value=>"")+options_from_collection_for_select(Device.available_devices, 'id', 'name'), class: "form-control")
  end

  def list_no_available_devices
    select_tag('car[device_id]', content_tag(:option,'No available devices', :value=>""), class: "form-control")
  end

  def list_devices_with_default(device)
    select_tag('car[device_id]', content_tag(:option, device.name, :value=> device.id )+content_tag(:option,'Detach device', :value=>"")+options_from_collection_for_select(Device.available_devices, 'id', 'name'), class: "form-control")
  end

  def no_available_drivers?
    User.available_drivers.count == 0 
  end

  def list_available_drivers
    select_tag('car[user_id]', content_tag(:option,'Select Driver ...', :value=>"")+options_from_collection_for_select(User.available_drivers, 'id', 'name_with_email'), class: "form-control")
  end

  def list_no_available_drivers
    select_tag('car[user_id]', content_tag(:option,'No available drivers', :value=>""), class: "form-control")
  end

  def list_drivers_with_default(driver)
    select_tag('car[user_id]', content_tag(:option, driver.name, :value=> driver.id )+options_from_collection_for_select(User.available_drivers, 'id', 'name_with_email'), class: "form-control")
  end

  def render_movement_status(car)
    if car.has_device? && car.moving?
      "Car is moving"
    elsif car.has_device?
      "Car isn't moving"
    else  
      "No GPS Data"
    end
  end

  def checked_radio_button(value, row)
    value == row
  end

  def pretty_time(created_at, default_value = "")
    created_at ? "#{created_at.hour}:#{created_at.min}:#{created_at.sec}" : default_value
  end

  def pretty_date(created_at, default_value = "")
    created_at ? "#{created_at.day}/#{created_at.month}/#{created_at.year}" : default_value
  end
end
