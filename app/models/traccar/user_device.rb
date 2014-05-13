class Traccar::UserDevice < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "users_devices"

    belongs_to :device, :class_name => "Traccar::Device", :foreign_key => :devices_id
    belongs_to :user, :class_name => "Traccar::User", :foreign_key => :users_id
end