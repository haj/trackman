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
  has_many :alarm_cars
  has_many :alarms, through: :alarm_cars

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

  # Nested Attr
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

  #############################
  # INSTANCE METHOD GOES HERE #
  #############################

  # 
  # Retrieve Last Location
  #
  def last_location
    self.last_position_with_address.address.truncate(55) rescue '-'
  end

  #
  # Retrieve Last Latitude
  #
  def last_latitude
    self.last_position.try(:latitude)
  end

  #
  # Retrieve Last Longitude
  #
  def last_longitude
    self.last_position.try(:longitude)
  end

  #
  # Retrieve Speed
  #
  def speed
    self.last_position.speed rescue 'undefined'
  end

  #
  # Retrieve last seend
  #
  def last_seen
    self.last_active_position.time rescue '-'
  end

  #
  # Retrieve last active position
  #
  def last_active_position
    self.device.locations.where(:state => ["start", "stop", "onroad", "idle"]).last if self.device
  end

  #
  # Retrieve last position
  #
  def last_position
    self.device.try(:last_position)
  end

  #
  # Retrieve last position with address
  #
  def last_position_with_address
    self.device.locations.where.not(address: nil).last if self.device
  end

  #
  # Retrieve time
  #
  def time
    self.positions.last.try(:time)
  end

  #
  # Retrieve address
  #
  def address
    self.positions.last.try(:address)
  end

  #
  # Retrieve positions
  #
  def positions
    if self.device
      self.device.traccar_device.positions.order("time DESC")
    else
      Hash.new
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
    !self.has_device? || self.device.no_data?
  end

  # Generate state card
  def capture_state
    state           = State.new
    state.moving    = self.moving?
    state.no_data   = self.no_data?
    state.speed     = self.speed
    state.car_id    = self.id
    state.driver_id = self.driver.id if self.has_driver?
    state.device_id = self.device.id if self.has_device?
    state.save!
  end

  # dates = {start_date, start_time, end_date, end_time}
  def positions_with_dates(dates, timezone)
    if dates.present?
      Time.use_zone("#{timezone}") do
        positions  = []
        start_date = Time.zone.parse("#{dates[:start_date]} #{dates[:start_time]}").utc
        end_date   = Time.zone.parse("#{dates[:end_date]} #{dates[:end_time]}").utc

        Location.where("time >= ? AND time <= ?", start_date.to_s(:db), end_date.to_s(:db)).order("time ASC")
      end
    else
      self.device.traccar_device.positions.order("time DESC").limit(100)
    end
  end

  def positions_for_date(day)
    date = Chronic.parse(day.to_s)
    self.positions.where("time > ? AND time < ?", date, date + 1.day)
  end

  # Class Method
  class << self
    # Positions
    def all_positions(cars)
      positions = Array.new

      cars.each do |car|
        if car.last_position.present?
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
      if car_id.present?
        Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL AND car_id != #{car_id}) AND deleted_at IS NULL")
      else
        Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL AND deleted_at IS NULL)")
      end
    end

    def cars_without_drivers(car_id)
      if car_id.present?
        Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL AND car_id != #{car_id})")
      else
        Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)")
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
