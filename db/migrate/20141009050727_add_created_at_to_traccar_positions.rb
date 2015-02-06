class AddCreatedAtToTraccarPositions < ActiveRecord::Migration
  
  ActiveRecord::Base.establish_connection("secondary_#{Rails.env}".to_sym)

  def change
  	unless column_exists? :positions, :created_at
    	execute "ALTER TABLE `positions` ADD `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP;" 
	end
    ActiveRecord::Base.establish_connection "#{Rails.env}"
  end

end

