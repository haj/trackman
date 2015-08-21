class ChangeSpeedClassInLocation < ActiveRecord::Migration
  def change
  	change_column :locations, :speed, :float
  end
end
