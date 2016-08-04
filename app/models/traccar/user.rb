# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  admin           :boolean
#  login           :string(255)
#  password        :string(255)
#  userSettings_id :integer
#

class Traccar::User < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "user"

  	has_many :devices, :through => :users_devices
    has_many :users_devices, :class_name => "Traccar::UserDevice", :foreign_key => 'userid', :dependent => :destroy

  	def last_position
  		position = self.positions.last
  		if position.nil?
  			return Hash.new
  		else
  			return {longitude: position.longitude, latitude: position.latitude }
  		end
  	end

end
