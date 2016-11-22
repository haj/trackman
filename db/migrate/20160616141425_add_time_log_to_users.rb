class AddTimeLogToUsers < ActiveRecord::Migration
  def change
    add_column :users, :time_log, :string, default: '00:00:00'
  end
end
