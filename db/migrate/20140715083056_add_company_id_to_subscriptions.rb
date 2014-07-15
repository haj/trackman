class AddCompanyIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :company_id, :integer
    add_column :subscriptions, :active, :boolean
  end
end
