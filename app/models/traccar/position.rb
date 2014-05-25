class Traccar::Position < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "positions"

  	include SafeAttributes::Base

  	belongs_to :device, :class_name => 'Traccar::Device'

  	bad_attribute_names :valid?
  	#validates_presence_of :valid?
  	
end