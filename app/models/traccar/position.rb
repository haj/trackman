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
#  fixTime       :datetime
#  valid      :boolean
#  device_id  :integer
#  created_at :timestamp        not null
#

class Traccar::Position < ActiveRecord::Base
  establish_connection "secondary_#{Rails.env}".to_sym
  self.table_name = "positions"

  include SafeAttributes::Base

  belongs_to :device, :class_name => 'Traccar::Device', :foreign_key => 'deviceid'
  has_one :location, :class_name => 'Location'

  bad_attribute_names :valid?
  #validates_presence_of :valid?

  reverse_geocoded_by :latitude, :longitude do |position,results|
    if geo = results.first
      position.location = Location.create(address: geo.address, city: geo.city, latitude: position.latitude, longitude: position.longitude, country: geo.country, state: geo.state, device_id: position.device_id, time: position.fixTime, speed: position.speed, valid_position: position.valid)
      position.update_attribute(:address, geo.address)
    end
  end

  def time_to_date
    self.fixTime.to_date
  end

  #after_create :reverse_code

  def reverse_code
    Rails.logger.warn "Running reverse_code"
    unless Rails.env.test? ||  Rails.env.development?
      Rails.logger.warn "Not in Rails.env.test"
      self.reverse_geocode
    end
  end

  def self.geocode
    Traccar::Position.where("fixTime >= ?", 10.days.ago).each do |position|
      if position.location.nil?
        puts "Processing"
        position.reverse_geocode
        sleep(1)
      end
    end
  end

  def self.geocode_all
    Traccar::Position.all.each do |position|
      if position.location.nil?
        puts "Processing"
        position.reverse_geocode
        sleep(1)
      end
    end
  end

  # def car
  #   Device.where(emei: self.device.uniqueId).first.car
  # end

  # Takes a bunch of positions and return it in a Gmaps4rails format
  def self.markers(positions)
    return Gmaps4rails.build_markers(positions) do |position, marker|
      marker.lat position.latitude.to_s
      marker.lng position.longitude.to_s
      marker.infowindow position.fixTime.to_s
    end
  end

end
