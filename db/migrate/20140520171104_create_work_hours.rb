class CreateWorkHours < ActiveRecord::Migration
  def change
    create_table :work_hours do |t|
      t.integer :day_of_week
      t.time :starts_at
      t.time :ends_at
      t.integer :device_id

      t.timestamps
    end
  end
end
