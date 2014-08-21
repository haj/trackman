class DropPositionTable < ActiveRecord::Migration
  def change
  	drop_table :positions
  end
end
