class AddCompanyIdToVertices < ActiveRecord::Migration
  def change
    add_column :vertices, :company_id, :integer
  end
end
