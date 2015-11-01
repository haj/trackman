# == Schema Information
#
# Table name: users_devices
#
#  users_id   :integer          not null
#  devices_id :integer          not null
#

class Traccar::UserDevice < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "user_device"

    belongs_to :device, class_name: 'Traccar::Device',
     				   foreign_key: :deviceId

    belongs_to :user, class_name: 'Traccar::User',
    				 foreign_key: :userId
end
