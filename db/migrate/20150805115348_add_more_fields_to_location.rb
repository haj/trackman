class AddMoreFieldsToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :city, :string
    add_column :locations, :country, :string
    add_column :locations, :state, :string
  end
end
