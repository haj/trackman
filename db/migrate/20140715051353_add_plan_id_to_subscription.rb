class AddPlanIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :plan_id, :integer
  end
end
