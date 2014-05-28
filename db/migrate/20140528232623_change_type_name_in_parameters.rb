class ChangeTypeNameInParameters < ActiveRecord::Migration
  def change
  	rename_column :parameters, :type, :data_type
  end
end
