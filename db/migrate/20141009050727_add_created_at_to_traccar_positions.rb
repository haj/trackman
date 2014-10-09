class AddCreatedAtToTraccarPositions < ActiveRecord::Migration
  def connection
    @connection ||= ActiveRecord::Base.establish_connection("secondary_#{Rails.env}").connection
  end

  def change
    execute "ALTER TABLE `positions` ADD `created_at` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;" 
    @connection = ActiveRecord::Base.establish_connection("#{Rails.env}").connection
  end
end

