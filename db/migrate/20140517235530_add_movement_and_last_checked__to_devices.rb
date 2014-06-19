class AddMovementAndLastCheckedToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :movement, :boolean
    add_column :devices, :last_checked, :date
  end
end
