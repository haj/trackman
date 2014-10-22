class AddCreatedAtToTraccarPositions < ActiveRecord::Migration
  
  def change
  	ActiveRecord::Base.establish_connection("secondary_#{Rails.env}".to_sym)
    execute "ALTER TABLE `positions` ADD `created_at` TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;" 
    ActiveRecord::Base.establish_connection "#{Rails.env}"
  end
end

