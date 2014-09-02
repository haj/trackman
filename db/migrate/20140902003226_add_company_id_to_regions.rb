class AddCompanyIdToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :company_id, :integer
  end
end
