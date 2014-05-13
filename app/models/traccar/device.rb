class Traccar::Device < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "devices"

  	has_many :positions, :class_name => 'Traccar::Position', :foreign_key => 'device_id', :dependent => :destroy
    has_many :users_devices, :class_name => "Traccar::UserDevice", :foreign_key => 'devices_id', :dependent => :destroy 
    has_many :users, :through => :users_devices

  	def last_position
  		position = self.positions.last
  		if position.nil?
  			return Hash.new
  		else 
  			return {longitude: position.longitude, latitude: position.latitude }
  		end
  	end
end