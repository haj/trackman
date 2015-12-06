class AddIgniteToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :ignite, :boolean, default: nil
  end
end
