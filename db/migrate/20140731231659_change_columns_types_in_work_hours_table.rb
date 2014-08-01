class ChangeColumnsTypesInWorkHoursTable < ActiveRecord::Migration
  def change
  	change_column :work_hours, :starts_at, :datetime
  	change_column :work_hours, :ends_at, :datetime
  	change_column :group_work_hours, :starts_at, :datetime
  	change_column :group_work_hours, :ends_at, :datetime
  end
end
