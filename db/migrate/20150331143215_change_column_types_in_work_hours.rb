class ChangeColumnTypesInWorkHours < ActiveRecord::Migration
  def change
  	change_column :work_hours, :starts_at,  :time
  	change_column :work_hours, :ends_at,  :time
  end
end
