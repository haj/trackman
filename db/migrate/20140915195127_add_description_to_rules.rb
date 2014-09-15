class AddDescriptionToRules < ActiveRecord::Migration
  def change
    add_column :rules, :description, :string
  end
end
