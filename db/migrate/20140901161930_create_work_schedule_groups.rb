class CreateWorkScheduleGroups < ActiveRecord::Migration
  def change
    create_table :work_schedule_groups do |t|
      t.integer :company_id
      t.integer :work_schedule_id

      t.timestamps
    end
  end
end
