class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :plan_type_id
      t.string :interval
      t.string :current
      t.float :price
      t.string :paymill_id

      t.timestamps
    end
  end
end
