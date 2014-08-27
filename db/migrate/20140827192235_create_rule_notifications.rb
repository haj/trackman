class CreateRuleNotifications < ActiveRecord::Migration
  def change
    create_table :rule_notifications do |t|
      t.integer :rule_id
      t.integer :car_id

      t.timestamps
    end
  end
end
