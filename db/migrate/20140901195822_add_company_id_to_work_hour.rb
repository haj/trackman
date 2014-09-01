class AddCompanyIdToWorkHour < ActiveRecord::Migration
  def change
    add_column :work_hours, :company_id, :integer
  end
end
