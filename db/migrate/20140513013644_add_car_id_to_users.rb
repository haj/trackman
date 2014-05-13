class AddCarIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :car_id, :integer
  end
end
