class AddCreatedAtToTraccarPositions < ActiveRecord::Migration
  def connection
    @connection ||= ActiveRecord::Base.establish_connection("secondary_#{Rails.env}").connection
  end

  def change
    add_column :ref_high_level_statuses, :is_in_progress, :boolean, :default => true
    @connection = ActiveRecord::Base.establish_connection("#{Rails.env}").connection
  end
end

