# == Schema Information
#
# Table name: positions
#
#  id        :integer          not null, primary key
#  address   :string(255)
#  altitude  :float
#  course    :float
#  latitude  :float
#  longitude :float
#  other     :string(255)
#  power     :float
#  speed     :float
#  time      :datetime
#  valid     :boolean
#  device_id :integer
#

class Traccar::Position < ActiveRecord::Base
  	establish_connection "secondary_#{Rails.env}".to_sym
  	self.table_name = "positions"

  	include SafeAttributes::Base

  	belongs_to :device, :class_name => 'Traccar::Device'

  	bad_attribute_names :valid?
  	#validates_presence_of :valid?
  	
end
