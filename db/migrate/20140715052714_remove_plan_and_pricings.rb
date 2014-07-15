class RemovePlanAndPricings < ActiveRecord::Migration
  def change
  	drop_table :plans
  	drop_table :pricings
  end
end
