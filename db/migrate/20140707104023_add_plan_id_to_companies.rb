class AddPlanIdToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :plan_id, :integer, default: (Plan.first.id rescue nil)
  end
end
