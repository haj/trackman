class RemoveConjunctionFromConditions < ActiveRecord::Migration
  def change
  	remove_column :conditions, :conjunction
  end
end
