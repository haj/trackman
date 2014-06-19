class ChangeLastCheckedTypeInDevices < ActiveRecord::Migration
  def change
   change_column :devices, :last_checked, :datetime
  end
end
