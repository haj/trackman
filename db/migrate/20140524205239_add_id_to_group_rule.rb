class AddIdToGroupRule < ActiveRecord::Migration
  def change
    add_column :groups_rules, :id, :primary_key
  end
end
