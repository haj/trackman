
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

	before_save :define_step

	def define_step
		if self.status == "start" or self.status == "stop"
			c = Location.order(:time).where('device_id', self.device_id)
			.where('time < ? and DATE(time) like ?', self.time, self.time.to_date)
			.where("status in (?,?)", "start", "stop").count
			self.step = c + 1
		end
	end

	# attr_reader :time

	# def time=(time)
	# 	time
	# end

	# def time=(value)
	#   value = value.to_date.to_s(:db)
	#   self[:time] = value
	# end

	def to_time
		self.time.strftime('%H:%M:%S')
	end

	def self.reset_locations
	    Location.all.destroy_all
	    Traccar::Position.where('time > ?', "2015-08-05".to_date).each do |p|
	        p.location = Location.create(address: p.address, device_id: p.device_id, latitude: p.latitude, longitude: p.longitude, time: p.time, speed: p.speed, valid_position: p.valid)
	    end
	    analyze_locations
	    p Location.all.count
	end

	def self.analyze_locations
	    Location.order(:time).all.each do |l|
	    	Location.where('time = ? and id != ?', l.time, l.id).destroy_all
		    l.analyze_me
	    end
	end

	# can be onroad, start, stop
	def analyze_me
		p = self.previous

		# self : current position
		# p    : previous position

		if p.nil?
			self.status = "start"
		else
			previous_start_point = self.previous_start_point
			duration_since_previous_point = (self.time - p.time).to_i
			# duration_since_previous_start_point = (self.time - previous_start_point.time).to_i

			if duration_since_previous_point > 300 and p.status != "start" # 5 minutes

				self.status = "start"

				# new start point, but what's the time that the vehicle had been parked?
				previous_start_point.parking_duration = duration_since_previous_point

				# if p.status == "start"
				# 	p.status = "error"
				# else
				# 	p.status = "stop"
				# end

				p.save!

				# new stop point, but what's the time that the vehicle had been driven?
				duration_since_previous_start_point = (p.time - previous_start_point.time).to_i
				previous_start_point.driving_duration = duration_since_previous_start_point

				previous_start_point.save!
			else
				self.status = "onroad"
			end
		end

		# Start 2 | Stop 5 | Start 3 | Stop 5

		self.save!

	end

	def self.destroy_similar_in_time
		Location.where('device_id', self.device_id).where('time like ?', self.time).destroy_all
	end

	def self.destroy_similar_in_address
		Location.all.select{|l| l.device_id == self.device_id and l.id < self.id and self.time - l.time < 60 and self.time - l.time > 0}.destroy_all
	end

	def total_parking_duration_of_the_day
		parking_duration_current_day = 0
		Location.order(:time).select{|l| l.time.to_date == self.time.to_date and l.status == "start"}.each do |l|
	    	parking_duration_current_day += l.parking_duration.to_i
		end
		Time.at(parking_duration_current_day).utc.strftime('%H:%M:%S')
	end

	def total_driving_duration_of_the_day
		driving_duration_current_day = 0
		Location.order(:time).select{|l| l.time.to_date == self.time.to_date and l.status == "start"}.each do |l|
	    	driving_duration_current_day += l.driving_duration.to_i
		end
		Time.at(driving_duration_current_day).utc.strftime('%H:%M:%S')
	end

	def previous_start_point
		Location.order(:time).where('device_id', self.device_id).where('time < ? and status like ?', self.time, 'start').last
	end

	def previous
		Location.order(:time).where('device_id', self.device_id).where('time < ?', self.time).last
	end

	def next
		Location.order(:time).where('device_id', self.device_id).where('time > ? and DATE(time) like ?', self.time, self.time.to_date).first
	end

  # Takes a bunch of locations and return it in a Gmaps4rails format
  def self.markers(locations)
    return Gmaps4rails.build_markers(locations) do |location, marker|
      marker.lat location.position.latitude.to_s
      marker.lng location.position.longitude.to_s
      marker.infowindow location.time.to_s+"/"+location.status
    end
  end

end
