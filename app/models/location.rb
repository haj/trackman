
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
	belongs_to :device

  reverse_geocoded_by :latitude, :longitude do |location,results|
    if geo = results.first
      location.update_attributes(address: geo.address, country: geo.country, city: geo.city)
    end
  end

	# before_save :analyze_me

	def get_todays_locs
		Location.order(:time).where('device_id = ? and time < ? and DATE(time) = ?', self.device_id, self.time, self.time.to_date)
	end

	def get_todays_start_locs
		self.get_todays_locs.where("state = ?", "start")
	end

	def is_first_position_of_day?
		self.get_todays_locs.empty?
	end

	# rule 1
	def is_first_point?
		if self.get_todays_locs.count == 0
			self.state = "start"
			# self.save!
			true
		end
		false
	end

	# rule 2
	def is_last_point?
		if self.get_todays_locs.count > 1 and self.previous.state != "stop"
			self.state = "stop"
			self.step = self.previous.step
			logger.warn locs.last.inspect
			self.save!
			true
		end
		false
	end

	# rule 3
	def been_parked?
		retur = false
		if self.previous
			if self.previous.ignition_is_off?
				retur = true
			else
				retur = false
			end
		else
			retur = true
		end
		retur
	end

	def been_idled?
		self.duration_since_previous > 300
	end

	# rule 4
	def ignore_similar

	end

	# rule 5
	def is_previous_stop?
		if self.previous.state == "stop"
			self.state = "start"
			self.set_as_next_step
			self.save!
		end
	end

	def ignition_is_on?
		self.ignite
	end

	def ignition_is_off?
		!self.ignite
	end

	# Defining when a car is driving or parked, and the parking, driving duration and pairs start and stop.
	# So routes can easily be recognized.
	# Based on these rules :
	# => rule 1 : the first position is always a starting point.
	# => rule 2 : the last position is always a stopping point.
	# => rule 3 : if a car has been parked for more than 5mnts, a stop and a start are generated.
	# => rule 4 : if a car hasn't change position, don't generate a new location but ignore it.
	# => rule 5 : there is always a start after a stop
	def analyze_me
		previous = self.previous

		if self.ignition_is_on?

			if self.is_first_position_of_day? or (previous.state == "stop" or previous.state == "signal")

				self.state = "start"
				self.set_as_current_step
				self.reverse_geocode
				logger.warn "current : "
				logger.warn self.inspect
				if self.previous
					logger.warn "previous : "
					logger.warn self.previous.inspect
				end

			else

				if self.been_idled?
					self.state = "idle"
					self.step = self.previous_start_point.try(:step)
					self.reverse_geocode
				else
					self.state = "onroad"
				end

			end

		else

			if previous.ignition_is_on?
				self.state = "stop"
				self.step = self.previous_start_point.try(:step)
				self.reverse_geocode
			else
				self.state = "signal"
			end

		end

		# if self.is_first_position_of_day? || self.been_parked?
		# 	self.state = "start"
		# 	self.set_as_current_step
		# 	self.reverse_geocode

		# 	if self.been_parked?
		# 		# self.previous_locations_with_same_time.destroy_all
		# 		previous = self.previous

		# 		if previous.state == "onroad"
		# 			previous.state = "stop"
		# 			previous.step = self.step - 1
		# 			previous.save!
		# 			previous.reverse_geocode

		# 			# calculating parking / driving time
		# 			previous_start_point = self.get_todays_start_locs.last
		# 			previous_start_point.parking_duration = self.calculate_parking_time
		# 			previous_start_point.driving_duration = self.calculate_driving_time
		# 			previous_start_point.save!
		# 		end

		# 	end

		# else
		# 	self.state = "onroad"
		# end

		self.save!
	end

	def duration_since_previous
		(self.time - self.previous.time).to_i if self.previous
	end

	def calculate_parking_time
		(self.time - self.previous.time).to_i
	end

	def calculate_driving_time
		(self.previous.time - self.get_todays_start_locs.last.time).to_i
	end

	def set_as_current_step
		self.step = self.get_todays_start_locs.count + 1
	end

	def set_as_next_step
		self.step = self.get_todays_start_locs.last.step + 1 if self.get_todays_start_locs.last != nil
		self.save!
	end

	# def status_code
	# 	if self.status_code
	# end

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

	def self.reset_locations_of_today
			# Location.where("DATE(time) = ?", DateTime.now.to_date).destroy_all
	    Traccar::Position.where("DATE(fixTime) = ?", DateTime.now.to_date).each do |p|
	    		device = Device.find_by_emei(Traccar::Device.find(p.deviceId).uniqueId)
	        l = Location.create(device_id: device.id, latitude: p.latitude, longitude: p.longitude, time: p.fixTime, speed: p.speed, valid_position: p.valid)
		    	jsoned_xml = JSON.pretty_generate(Hash.from_xml(p.other))
		    	ignite = JSON[jsoned_xml]["info"]["power"]
		    	l.ignite = ignite if ignite != ""
		    	l.save!
	    end
	    Location.order(:time).where("DATE(time) = ?", DateTime.now.to_date).each do |l|
		    l.analyze_me
	    end
	end

	def self.reset_locations
	    Location.all.each do |l|
	    	l.state = ""
	    	l.save!
	    end
	    Location.all.each do |l|
	    	l.analyze_me
	    	l.save!
	    end
	end

	def self.analyze_locations
	    Location.order(:time).all.each do |l|
	    	# Location.where('time = ? and id != ?', l.time, l.id).destroy_all
		    l.analyze_me
	    end
	end

	def self.analyze_locations_of_today
	    Location.order(:time).where("DATE(time) = ?", DateTime.now.to_date).each do |l|
		    l.analyze_me
	    end
	end

	def self.destroy_similar_in_time
		Location.where('device_id', self.device_id).where('time = ?', self.time).destroy_all
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
		Location.order(:time).where('device_id = ?', self.device_id).where('DATE(time) = ? and time < ? and state = ?', self.time.to_date, self.time, 'start').last
	end

	def previous
		Location.order(:time).where('device_id = ? and DATE(time) = ? and time < ?', self.device_id, self.time.to_date, self.time).last
	end

	def previous_locations_with_same_time
		Location.where('device_id = ? and DATE(time) = ? and time <= ? and id != ?', self.device_id, self.time.to_date, self.time, self.id)
	end

	def next
		Location.order(:time).where('device_id = ?', self.device_id).where('time > ? and DATE(time) = ?', self.time, self.time.to_date).first
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
