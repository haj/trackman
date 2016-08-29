class CreatePlans < ActiveRecord::Migration
  def change
    unless Plan.table_exists?
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
end
