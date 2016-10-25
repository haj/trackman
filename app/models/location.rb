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
  # ASSOCIATION
  belongs_to :position, :class_name => 'Traccar::Position'
  belongs_to :device

  # validation
  # validates :device_id, :position_id, presence: true

  # CALLBACKS
  # after_commit :get_traccar_data, on: :create

  reverse_geocoded_by :latitude, :longitude do |location,results|
    if geo = results.first
      location.update_attributes(address: geo.address, country: geo.country, city: geo.city)
    end
  end

  def get_todays_locs
    Location.order(:time).where('device_id = ? and time < ? and DATE(time) = ?', self.device_id, self.time, self.time.to_date)
  end

  def get_todays_start_locs
    self.get_todays_locs.where("state = ?", "start")
  end

  def is_first_position_of_day?
    self.get_todays_locs.empty?
  end

  def is_first_park_of_the_day?
    self.get_todays_locs.where("state = ?", "stop").present?
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
  # def analyze_me
    # statistics = CarStatistic.find_or_create_by(car_id: self.device.car.id, time: self.time.to_date)

    # statistic_distance(statistics)

    # if is_first_position_of_day? or statistics.last_is_stop?
    #   duration_since_last_stop = (time - statistics.last_stop.time).to_i rescue 0

    #   if ignition_is_on? && ((statistics.last_stop && (duration_since_last_stop > Settings.minimum_parking_time.to_i * 60)) || !statistics.last_stop)
    #     self.state = "start"
    #     statistics.steps_counter += 1
    #     statistics.last_start = self
    #     statistics.last_is = self
    #     self.trip_step = statistics.steps_counter
    #     self.reverse_geocode
    #   else
    #     puts "how can we got in here. is it possible?"
    #     self.state = "ignore"
    #   end    
    # else
    #   if ignition_is_on?
    #     self.state = "onroad"
    #   else # if ignition is off
    #     distance_from_last_start  = distance_from [statistics.last_start.latitude, statistics.last_start.longitude]
    #     duration_since_last_start = (time - statistics.last_start.time).to_i
    #     if statistics.last_stop
    #       distance_from_last_stop  = distance_from [statistics.last_stop.latitude, statistics.last_stop.longitude]
    #       duration_since_last_stop = (time - statistics.last_stop.time).to_i
    #     end

    #     if (distance_from_last_start >= 0.01 or duration_since_last_start > 300) && statistics.last_is_start? # 10 meters
    #       self.state = "stop"
    #       self.ignite_step = previous_start_point.try(:ignite_step)
    #       self.trip_step = statistics.steps_counter
    #       self.reverse_geocode
    #       statistics.last_stop = self
    #       statistics.last_is = self

    #       # calculating parking / driving time
    #       previous_start_point = statistics.last_start
    #       previous_start_point.driving_duration = duration_since_last_start
    #       previous_start_point.parking_duration = previous_start_point.calculate_parking_time
    #       previous_start_point.save!

    #       statistics.tparktime += previous_start_point.parking_duration if previous_start_point.parking_duration
    #       statistics.tdrivtime += previous_start_point.driving_duration if previous_start_point.driving_duration

    #       arr_speed = get_todays_locs.map{|l| l.speed}

    #       statistics.avgspeed = arr_speed.inject{ |sum, el| sum+el }.to_f / arr_speed.size
    #       statistics.maxspeed = self.get_todays_locs.map{|l| l.speed}.max    

    #       # ignite_stop(statistics)
    #     else
    #       self.state = "ignore"
    #     end
    #   end    
    # end
    
    # statistics.save!
    # self.save!
  # end

  def analyze_me
    statistics = CarStatistic.find_or_create_by(car_id: self.device.try(:car).try(:id), time: self.time.to_date)

    unless Location.greater_than_last_time?(device_id, time)
      case statistics.aasm_state
      when 'start'
        on_road(statistics)
      when 'onroad'
        onroad_state(statistics)
      else
        on_start(statistics)
      end

      statistics.save!
      self.save!    
    end
  end

  #
  # on road state action
  #
  def onroad_state(statistics)
    distance_from_last_start  = distance_from [statistics.last_start.latitude, statistics.last_start.longitude]
    duration_since_last_start = (time - statistics.last_start.time).to_i

    if ignition_is_off? && (distance_from_last_start >= 0.01 or duration_since_last_start > 300)
      on_stop(statistics, duration_since_last_start)
    else
      on_road(statistics)
    end    
  end

  #
  # on start
  #
  def on_start(statistics)
    if ignition_is_on? && !statistics.start?
      statistic_distance(statistics)

      step       = is_first_position_of_day? ? 1 : (statistics.steps_counter += 1)
      self.state = "start"
      self.parking_duration = (Time.now - Date.today.to_time).to_i if is_first_position_of_day?
      statistics.aasm_state = 'start'
      statistics.steps_counter = step
      statistics.last_start = self
      statistics.last_is = self
      self.trip_step = statistics.steps_counter
      self.reverse_geocode        
    end    
  end

  #
  # On road
  #
  def on_road(statistics)
    statistic_distance(statistics)

    self.state = 'onroad'
    statistics.run    
  end

  #
  # on stop
  #
  def on_stop(statistics, duration_since_last_start)
    statistic_distance(statistics)

    self.state = "stop"
    self.ignite_step = previous_start_point.try(:ignite_step)
    self.trip_step = statistics.steps_counter
    self.reverse_geocode
    statistics.last_stop = self
    statistics.last_is = self
    statistics.park      

    # calculating parking / driving time
    previous_start_point = statistics.last_start
    previous_start_point.driving_duration = duration_since_last_start
    previous_start_point.parking_duration = previous_start_point.calculate_parking_time
    previous_start_point.save!

    statistics.tparktime += previous_start_point.parking_duration if previous_start_point.parking_duration
    statistics.tdrivtime += previous_start_point.driving_duration if previous_start_point.driving_duration

    arr_speed = get_todays_locs.map{|l| l.speed}

    avg                 = arr_speed.inject{ |sum, el| sum+el }.to_f / arr_speed.size
    statistics.avgspeed = avg.to_f.nan? ? 0 : avg
    statistics.maxspeed = self.get_todays_locs.map{|l| l.speed}.max    
  end

  #
  # Statistic distance from previous locations
  #
  def statistic_distance(statistics)
    if previous
      distance_from_previous = distance_from [previous.latitude, previous.longitude]
      if distance_from_previous
        statistics.tdistance += distance_from_previous
        statistics.tdistance = statistics.tdistance.round(2)
      end
    end    
  end

  def duration_since_previous
    (self.time - self.previous.time).to_i if self.previous
  end

  def calculate_parking_time
    statistics = CarStatistic.find_or_create_by(car_id: self.device.try(:car).try(:id), time: self.time.to_date)

    if statistics.last_is.trip_step == 1
      time_log = self.device.try(:car).try(:driver).nil? ? '00:00:00' : self.device.try(:car).try(:driver)
      (self.time - time_log.to_time).to_i
    else
      (self.time - self.previous_stop_point.time).to_i if self.previous_stop_point
    end
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

  def to_time
    self.time.strftime('%H:%M:%S')
  end

  def lat
    self.latitude
  end

  def lng
    self.longitude
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

  class << self
    # Takes a bunch of locations and return it in a Gmaps4rails format
    def markers(locations)
      return Gmaps4rails.build_markers(locations) do |location, marker|
        marker.lat location.position.latitude.to_s
        marker.lng location.position.longitude.to_s
        marker.infowindow location.time.to_s+"/"+location.status
      end
    end

    def device_with_date(date, device_id)
      Location.find_by_sql(["
        SELECT latitude, longitude, speed, state, address, ignite_step, trip_step 
        FROM locations 
        WHERE DATE(time) = ? and device_id = ?", date, device_id
      ])      
    end

    def greater_than_last_time?(device_id, time)
      Location.where("
        state in (?) AND device_id = ? AND time > ?", 
        ["start", "stop"], device_id, time
      ).present?
    end
  end
end
