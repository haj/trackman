#
# == Schema Information
#
# Table name: cars
#
#  id               :integer          not null, primary key
#  mileage          :float(24)
#  numberplate      :string(255)
#  car_model_id     :integer
#  car_type_id      :integer
#  registration_no  :string(255)
#  year             :integer
#  color            :string(255)
#  group_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  company_id       :integer
#  work_schedule_id :integer
#  name             :string(255)
#  deleted_at       :datetime
#

class Car < ActiveRecord::Base
  # INIT GEM
  acts_as_paranoid
  acts_as_messageable
  acts_as_tenant(:company)
  include PublicActivity::Common
  include ActionView::Helpers::DateHelper

  # Associations
  belongs_to :company
  belongs_to :car_model
  belongs_to :car_type
  belongs_to :work_schedule
  belongs_to :group
  has_one :device, :dependent => :nullify
  has_one :driver, :class_name => "User", :foreign_key => "car_id"
  has_many :car_statistics
  has_many :states, :dependent => :destroy
  has_many :locations, :through => :device
  has_many :alarm_cars, :dependent => :destroy
  #has_many :work_hours
  has_and_belongs_to_many :alarms

  # validation
  validates :name, :numberplate, presence: true

  # Scopes
  scope :by_car_model, -> car_model_id { where(:car_model_id => car_model_id) }
  scope :by_car_type, -> car_type_id { where(:car_type_id => car_type_id) }
  scope :traceable, -> { where("id IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL)") }
  scope :untraceable, -> { where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL)") }
  scope :with_driver, -> { where("id IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)") }
  scope :without_driver, -> { where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)") }
  scope :locations_of_the_following_dates, -> array_dates { where("DATE(time) IN (?)", array_dates) }

  # ATTR ACCESSOR GOES HERE
  attr_accessor :device_id, :user_id
  accepts_nested_attributes_for :alarms

  # Callback
  after_save :update_device, :update_driver

  def update_driver
    if user_id.present?
      user = User.find(user_id) 
      user.update(car_id: self.id)
    end    
  end

  def update_device
    if self.device_id.present?
      self.device.update(car_id: nil) if self.device

      device = Device.find(self.device_id)
      device.update(car_id: self.id)
    end
  end

  # INSTNCE METHOD GOES HERE
  def locations_grouped_by_dates
    self.locations.order(:time).group_by{|l| l.time.to_date}
  end

  def last_location
    unless self.last_position_with_address.nil?
      unless self.last_position_with_address.address.nil?
        return self.last_position_with_address.address.truncate(55)
      end
    end
    "-"
  end

  def last_latitude
    unless self.last_position.nil?
      unless self.last_position.latitude.nil?
        return self.last_position.latitude
      end
    end
    nil
  end

  def last_longitude
    unless self.last_position.nil?
      unless self.last_position.longitude.nil?
        return self.last_position.longitude
      end
    end
    nil
  end

  def speed
    unless self.last_position.nil?
      unless self.last_position.speed.nil?
        return self.last_position.speed
      end
    end
    "undefined"
  end


  def last_seen
    unless self.last_active_position.nil?
      unless self.last_active_position.time.nil?
        return self.last_active_position.time
      end
    end
    "-"
  end

  def last_active_position
    unless self.device.nil?
      return self.device.locations.where(:state => ["start", "stop", "onroad", "idle"]).last
    end
  end

  # Generate a hash with latitude and longitude of the car (fetched through the device GPS data)
  #   Also for this hash to be non-empty, the car must have a device associated with it in the database

  def last_position
    unless self.device.nil?
      return self.device.locations.last
      # return self.device.last_position
    end
  end

  def last_position_with_address
    unless self.device.nil?
      return self.device.locations.where.not(address: nil).last
    end
  end

  def time
    self.positions.last.time
  end

  def address
    self.positions.last.address
  end

  def positions
    if self.device.nil?
      # if this car doesn't have a device attached to it
      #   then just send an empty hash for the position
      return Hash.new
    else
      self.device.traccar_device.positions.order("time DESC")
    end
  end

  # Has?

  def has_device?
    device.present?
  end

  def has_driver?
    driver.present?
  end

  def has_group?
    group.present?
  end

  # Rule accessors

  # fetch name of the rule associated with this car
  def alarm_status(alarm)
    car_alarms.where(alarm_id: rule.id, car_id: id).first.status
  end

  # fetch last_alert time of the rule associated with this car
  def alarm_last_alert(alarm)
    car_alarms.where(alarm_id: rule.id, car_id: id).first.last_alert
  end

  # Alarms
  # Verificators

  # return if the car is moving or not
  def moving?
    if no_data?
      false
    else
      self.device.moving?
    end
  end

  # return if the we're receiving data or not from the car
  def no_data?
    # check if last time a new position reported is longer than x minutes
    has_no_device = !self.has_device?
    has_no_data = self.device.no_data?
    return has_no_device || has_no_data
  end

  # Alarms trigger
  def check_alarms
    # don't waste time checking if vehicle doesn't have device
    return unless self.device

    results = {}

    self.alarms.all.each do |alarm|
      trigger = alarm.verify(self.id)

      if trigger == true
        if ActsAsTenant.current_tenant.nil?
          ActsAsTenant.current_tenant = self.company
        end

        # create alarm notification (so the same alarm doesn't get triggered too much times)
        @alarm = AlarmNotification.create(alarm_id: alarm.id, car_id: self.id)
        
        puts "Create activity for notification"
        @alarm.create_activity :create, owner: self

        results["#{alarm.name}"] = {status: true, car_id: self.id }
        Rails.logger.debug "Alarm : #{alarm.name} | Status : true"

        # Send email notification to managers
        subject =  "Alarm : #{alarm.name}"
        body = alarm.name
        #self.company.users.first.notify(subject, body, self)
        #send email to user with name of the alarm triggered
        #AlarmMailer.alarm_email(self.company.users.first, self, alarm).deliver
      else
        results["#{alarm.name}"] = {status: false, car_id: self.id }
        Rails.logger.debug "Alarm : #{alarm.name} | Status : false"
      end
    end

    return results

    # capture the current car state
    # self.capture_state
  end

  # Generate state card
  def capture_state
    state = State.new
    state.moving = self.moving?
    state.no_data = self.no_data?
    state.speed = self.speed
    state.car_id = self.id
    state.driver_id = self.driver.id if self.has_driver?
    state.device_id = self.device.id if self.has_device?
    state.save!
  end

  # dates = {start_date, start_time, end_date, end_time}
  def positions_with_dates(dates, timezone)
    if dates.nil?
      self.device.traccar_device.positions.order("time DESC").limit(100)
    else
      Time.use_zone("#{timezone}") do
        positions  = []
        start_date = Time.zone.parse("#{dates[:start_date]} #{dates[:start_time]}").utc
        end_date   = Time.zone.parse("#{dates[:end_date]} #{dates[:end_time]}").utc

        # dates[:limit_results] = 20 if dates[:limit_results].to_i == 0
        # positions = self.device.traccar_device.positions.where("time >= ? AND time <= ?", start_date.to_s(:db), end_date.to_s(:db)).order("time ASC")

        Location.where("time >= ? AND time <= ?", start_date.to_s(:db), end_date.to_s(:db)).order("time ASC")
      end
    end
  end

  def positions_for_date(day)
    date = Chronic.parse(day.to_s)
    self.positions.where("time > ? AND time < ?", date, date + 1.day)
  end

  def distance
  end

  # Class Method
  class << self
    # Positions
    def all_positions(cars)
      positions = Array.new

      cars.each do |car|
        if !car.last_position.nil?
          positions << car.last_position
        end
      end

      positions
    end

    def one_car_position(car)
      position = Array.new
      position << car.last_position
      position
    end

    # Cars for devices
    def cars_without_devices(car_id)
      if car_id.nil?
        Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL AND deleted_at IS NULL)")
      else
        Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL AND car_id != #{car_id}) AND deleted_at IS NULL")
      end
    end

    def cars_without_drivers(car_id)
      if car_id.nil?
        Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)")
      else
        Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL AND car_id != #{car_id})")
      end
    end

    def locations_grouped_by_these_dates(dates, car_id)
      # Location.find_by_sql(["SELECT * FROM locations INNER JOIN devices ON locations.device_id = devices.id INNER JOIN cars ON devices.car_id = cars.id WHERE (cars.id = ? AND locations.state in(?) AND DATE(locations.time) in (?)) GROUP BY locations.trip_step, locations.state", car_id, ["start", "stop"], dates]).group_by{|l| l.time.to_date}
      Location.find_by_sql(["
        SELECT * FROM locations 
        INNER JOIN devices ON locations.device_id = devices.id 
        INNER JOIN cars ON devices.car_id = cars.id 
        WHERE (cars.id = ? AND locations.state in(?) AND DATE(locations.time) in (?)) 
        GROUP BY locations.trip_step, locations.state", car_id, ["start", "stop"], dates])
      .group_by{|l| l.time.to_date}
    end

  end
end
