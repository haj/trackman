
# == Schema Information
#
# Table name: locations
#
#  id          :integer          not null, primary key
#  address     :string(255)
#  position_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Location < ActiveRecord::Base
	belongs_to :position, :class_name => 'Traccar::Position'
	belongs_to :device, :class_name => 'Traccar::Device'
	after_create :if_start_point

	def self.locations_with_distance_between distance = 0.02
		
	end

	def if_start_point
        if !self.previous.nil?
          time_diff = Time.diff(self.previous.time, self.time)
          if time_diff[:minute] > 5
            self.start_point = true
            self.previous.stop_point = true
            self.save!
            self.previous.save!
          end
        end
	end

	def previous
		Location.where('device_id', self.device_id).where('time < ?', self.time).last
	end

	def previous_stop_position
		Location.where('device_id', self.device_id).where('stop_point like ?', true).where('time < ?', self.time).last
	end

	def previous_start_position
		Location.where('device_id', self.device_id).where('start_point like ?', true).where('time < ?', self.time).last
	end

	def next
		Location.where('device_id', self.device_id).where('time > ?', self.time).first
	end

  # Takes a bunch of locations and return it in a Gmaps4rails format 
  def self.markers(locations)
    return Gmaps4rails.build_markers(locations) do |location, marker|
      marker.lat location.position.latitude.to_s
      marker.lng location.position.longitude.to_s
      marker.infowindow location.time.to_s
    end 
  end
  
end
