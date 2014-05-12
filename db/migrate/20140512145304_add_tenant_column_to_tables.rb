class AddTenantColumnToTables < ActiveRecord::Migration
  def change
    add_column :cars, :company_id, :integer
    add_column :devices, :company_id, :integer
    add_column :simcards, :company_id, :integer
    add_column :groups, :company_id, :integer
  end
end
