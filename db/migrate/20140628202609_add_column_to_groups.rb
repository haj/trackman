class AddColumnToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :work_schedule_id, :integer
  end
end
