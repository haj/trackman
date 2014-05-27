class RenameDeviceIdToCarIdInWorkHours < ActiveRecord::Migration
  def change
	rename_column :work_hours, :device_id, :car_id
  end
end
