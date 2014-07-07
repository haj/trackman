class CreatePricings < ActiveRecord::Migration
  def change
    create_table :pricings do |t|
      t.string :name
      t.integer :billable_days
      t.float :amount
      t.integer :plan_id

      t.timestamps
    end
  end
end
