class CreateGroupWorkHours < ActiveRecord::Migration
  def change
    create_table :group_work_hours do |t|
      t.integer :day_of_week
      t.time :starts_at
      t.time :ends_at
      t.integer :group_id

      t.timestamps
    end
  end
end
