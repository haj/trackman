# == Schema Information
#
# Table name: locations
#
#  id               :integer          not null, primary key
#  address          :string(255)
#  position_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  city             :string(255)
#  country          :string(255)
#  state            :string(255)
#  device_id        :integer
#  time             :datetime
#  speed            :float(24)
#  valid_position   :boolean
#  driving_duration :string(255)
#  parking_duration :string(255)
#  longitude        :float(24)
#  latitude         :float(24)
#  status           :string(255)
#  ignite_step      :integer
#  ignite           :boolean
#  avg              :float(24)
#  max              :float(24)
#  min              :float(24)
#  trip_step        :integer
#  step_distance    :float(24)
#

class Location < ActiveRecord::Base
	belongs_to :position, :class_name => 'Traccar::Position'
	belongs_to :device

	# after_create :push_to_ui

	# def push_to_ui
	# 	$redis.publish 'rt-change', self.to_json
	# end

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
			self.ignite_step = self.previous.ignite_step
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

		statistics = CarStatistic.find_or_create_by(car_id: self.device.car.id, time: self.time.to_date)

		if previous != nil
			distance_from_previous = self.distance_from [previous.latitude, previous.longitude]
			statistics.tdistance += distance_from_previous
			statistics.tdistance = statistics.tdistance.round(2)
		end

		puts "Analyze me started!!!!"

		self.ignite = true if self.device_id == 13

		if self.is_first_position_of_day? or statistics.last_is_stop?

			if self.ignition_is_on?
				if statistics.last_stop
					duration_since_last_stop = (self.time - statistics.last_stop.time).to_i
					if duration_since_last_stop > Settings.minimum_parking_time.to_i * 60
						self.state = "start"
						statistics.steps_counter += 1
						statistics.last_start = self
						statistics.last_is = self
						self.trip_step = statistics.steps_counter
						self.reverse_geocode
					end
				else
					self.state = "start"
					statistics.steps_counter += 1
					statistics.last_start = self
					statistics.last_is = self
					self.trip_step = statistics.steps_counter
					self.reverse_geocode
				end
			else
				self.state = "ignore"
			end

		else

			if self.ignition_is_on?
				self.state = "onroad"
			else # if ignition is off
				distance_from_last_start = self.distance_from [statistics.last_start.latitude, statistics.last_start.longitude]
				duration_since_last_start = (self.time - statistics.last_start.time).to_i
				if statistics.last_stop
				distance_from_last_stop = self.distance_from [statistics.last_stop.latitude, statistics.last_stop.longitude]
				duration_since_last_stop = (self.time - statistics.last_stop.time).to_i
				end

				if (distance_from_last_start >= 0.01 or duration_since_last_start > 300) and statistics.last_is_start? # 10 meters
					self.state = "stop"
					self.ignite_step = self.previous_start_point.try(:ignite_step)
					self.trip_step = statistics.steps_counter
					self.reverse_geocode
					statistics.last_stop = self
					statistics.last_is = self

					# calculating parking / driving time
					previous_start_point = statistics.last_start
					previous_start_point.driving_duration = duration_since_last_start
					previous_start_point.parking_duration = previous_start_point.calculate_parking_time
					previous_start_point.save!

					statistics.tparktime += previous_start_point.parking_duration if previous_start_point.parking_duration != nil
					statistics.tdrivtime += previous_start_point.driving_duration if previous_start_point.driving_duration != nil

					arr_speed = self.get_todays_locs.map{|l| l.speed}

					statistics.avgspeed = arr_speed.inject{ |sum, el| sum+el }.to_f / arr_speed.size
					statistics.maxspeed = self.get_todays_locs.map{|l| l.speed}.max
				else
					self.state = "ignore"
				end
			end
		end

		puts "SAVING ...."
		statistics.save! if statistics != nil
		puts "#{statistics.inspect}"
		self.save!
	end

	def duration_since_previous
		(self.time - self.previous.time).to_i if self.previous
	end

	def calculate_parking_time
		(self.time - self.previous_stop_point.time).to_i if self.previous_stop_point
	end

	def calculate_driving_time
		(self.previous.time - self.get_todays_start_locs.last.time).to_i
	end

	def set_as_current_step
		self.ignite_step = self.get_todays_start_locs.count + 1
	end

	def set_as_next_step
		self.ignite_step = self.get_todays_start_locs.last.ignite_step + 1 if self.get_todays_start_locs.last != nil
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

	def self.reset_all_locations
			Location.all.destroy_all
	    Traccar::Position.all.where(:deviceid => 4).where('DATE(fixTime) > ? and DATE(fixTime) <= ?', "2015-11-05 06:15:07", "2015-11-10 21:15:07").each do |p|
	    		puts "cool"
	    		device = Device.find_by_emei(Traccar::Device.find(p.deviceid).uniqueId)
	        l = Location.create(device_id: device.id, latitude: p.latitude, longitude: p.longitude, time: p.fixTime, speed: p.speed, valid_position: p.valid, position_id: p.id)
		    	jsoned_xml = JSON.pretty_generate(Hash.from_xml(p.other))
		    	ignite = JSON[jsoned_xml]["info"]["power"]
		    	l.ignite = ignite if ignite != ""
		    	l.save!
	    end
	    Location.order(:time).each do |l|
		    l.analyze_me
	    end
	end

	def self.reset_locations_of_today
			# Location.where("DATE(time) = ?", DateTime.now.to_date).destroy_all
	    Traccar::Position.where("DATE(fixTime) = ?", DateTime.now.to_date).each do |p|
	    		device = Device.find_by_emei(Traccar::Device.find(p.deviceid).uniqueId)
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

	def self.analyze_locations_off time, did
	    Location.order(:time).where("DATE(time) = ? and device_id = ?", time, did).each do |l|
		    l.analyze_me
	    end
	end

	def self.reset_locations_off time, did
	    Location.where("DATE(time) = ? and device_id = ?", time, did).destroy_all
	    device = Device.find(did)
	    #reset car statistics
	    device.car.car_statistics.where("DATE(time) = ?", time).destroy_all
	    #Go through traccar position table
	    traccar_device_id = Traccar::Device.find_by_uniqueId(device.emei).id
	    Traccar::Position.where("DATE(fixTime) = ? and deviceid = ?", time, traccar_device_id).each do |p|
	        l = Location.create(device_id: did, latitude: p.latitude, longitude: p.longitude, time: p.fixTime, speed: p.speed.to_f * 1.852, valid_position: p.valid)
		    	jsoned_xml = JSON.pretty_generate(Hash.from_xml(p.other))
		    	ignite = JSON[jsoned_xml]["info"]["power"]
		    	l.ignite = ignite if ignite != ""
		    	l.save!
	    end
	    Location.order(:time).where("DATE(time) = ? and device_id = ?", time, did).each do |l|
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

	def lat
		self.latitude
	end

	def lng
		self.longitude
	end

	def self.analyze_locations
	    Location.order(:time).where(:device_id => 4).each do |l|
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

	def previous_stop_point
		Location.order(:time).where('device_id = ?', self.device_id).where('time < ? and state = ?', self.time, 'stop').last
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

	def self.get_traccar_data params
	    lat = params[:latitude]
	    lon = params[:longitude]
	    device_id = params[:device_id]
	    unique_id = params[:unique_id]
	    position_id = params[:position_id]
	    fix_time = params[:fix_time]
	    valid = params[:valid]
	    speed = params[:speed] # Speed in Knots
	    status = params[:status]
	    device = Device.find_by_emei(unique_id)

	    position = Traccar::Position.find position_id
	    jsoned_xml = JSON.pretty_generate(Hash.from_xml(position.other))
	    ignite = JSON[jsoned_xml]["info"]["power"]

	    # Conversion of speed from knots to km/h
	    speed = speed.to_f * 1.852

	    l = Location.create(device_id: device.id, latitude: lat, longitude: lon, time: fix_time, speed: speed, valid_position: valid,
	        position_id: position_id, status: status)

	    if ignite != ""
	        l.ignite = ignite
	    end

	    l.analyze_me

	    puts "!!! FROM TRACCAR !!!"
	    puts params
	    # render :json => nil
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
