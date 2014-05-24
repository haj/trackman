class AddIdToCarRule < ActiveRecord::Migration
  def change
    add_column :cars_rules, :id, :primary_key
  end
end
