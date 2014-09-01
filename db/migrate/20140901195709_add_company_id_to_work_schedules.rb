class AddCompanyIdToWorkSchedules < ActiveRecord::Migration
  def change
    add_column :work_schedules, :company_id, :integer
  end
end
