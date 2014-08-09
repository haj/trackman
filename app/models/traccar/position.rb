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

  	has_one :location, :class_name => "Traccar::Location"

  	bad_attribute_names :valid?
  	#validates_presence_of :valid?

  	reverse_geocoded_by :latitude, :longitude do |obj,results|
	  if geo = results.first
	  	obj.location = Traccar::Location.create(address: geo.address)
	  end
	end
	after_validation :reverse_geocode
  	
end
