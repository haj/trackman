# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  altitude   :float
#  course     :float
#  latitude   :float
#  longitude  :float
#  other      :string(255)
#  power      :float
#  speed      :float
#  time       :datetime
#  valid      :boolean
#  device_id  :integer
#  created_at :timestamp        not null
#

class Traccar::Position < ActiveRecord::Base 
  establish_connection "secondary_#{Rails.env}".to_sym
  self.table_name = "positions"

  include SafeAttributes::Base

  belongs_to :device, :class_name => 'Traccar::Device'
  has_one :location, :class_name => "Traccar::Location"

  bad_attribute_names :valid?
  #validates_presence_of :valid?

  reverse_geocoded_by :latitude, :longitude do |position,results|
    if geo = results.first
    	position.location = Traccar::Location.create(address: geo.address)
    end
  end

  after_validation :reverse_geocode

  def car
    Device.where(emei: self.device.uniqueId).first.car
  end

  def self.geocode 
    Traccar::Position.all.each do |position|
      if position.location.nil?
        puts "Processing"
        position.reverse_geocode
      end
      sleep(2)
    end
  end


  

  	
end
