class TDevice < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "devices"

  	#has_many  :positions, :class_name => 'TPosition', :foreign_key => 'device_id'

  	def last_position
  		position = self.positions.last
  		if position.nil?
  			return Hash.new
  		else 
  			return {longitude: position.longitude, latitude: position.latitude }
  		end
  	end
end