class AddIndexPositionIdToImportStatuses < ActiveRecord::Migration
  def change
  	change_column :import_statuses, :position_id, :integer, index: true
  end
end
