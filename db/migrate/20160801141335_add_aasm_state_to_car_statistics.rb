class AddAasmStateToCarStatistics < ActiveRecord::Migration
  def change
    add_column :car_statistics, :aasm_state, :string, default: 'stop'
  end
end
