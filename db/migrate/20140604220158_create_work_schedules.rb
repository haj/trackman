class CreateWorkSchedules < ActiveRecord::Migration
  def change
    create_table :work_schedules do |t|
      t.integer :car_id
      t.string :name

      t.timestamps
    end
  end
end
