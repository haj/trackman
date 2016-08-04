# == Schema Information
#
# Table name: devices
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  uniqueId          :string(255)
#  latestPosition_id :integer
#

class Traccar::Device < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "device"

    # validation
    validates_uniqueness_of :uniqueId, case_sensitive: false

  	has_many :positions, :class_name => 'Traccar::Position', :foreign_key => 'deviceid', :dependent => :destroy
    has_many :users_devices, :class_name => "Traccar::UserDevice", :foreign_key => 'deviceid'
    has_many :users, :through => :users_devices

  	def last_position
  		self.positions.last
  	end

    def last_positions(number)
      self.positions.order("time DESC").limit(number)
    end

end
