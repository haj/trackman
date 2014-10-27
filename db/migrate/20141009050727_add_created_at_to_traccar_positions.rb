class AddCreatedAtToTraccarPositions < ActiveRecord::Migration
  
  ActiveRecord::Base.establish_connection("secondary_#{Rails.env}".to_sym)
  def change
    execute "ALTER TABLE `positions` ADD `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;" 
    ActiveRecord::Base.establish_connection "#{Rails.env}"
  end
end

