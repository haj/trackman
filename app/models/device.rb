# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  emei            :string(255)
#  cost_price      :float(24)
#  created_at      :datetime
#  updated_at      :datetime
#  device_model_id :integer
#  device_type_id  :integer
#  car_id          :integer
#  company_id      :integer
#  movement        :boolean
#  last_checked    :datetime
#  deleted_at      :datetime
#

class Device < ActiveRecord::Base
  # INIT GEM
  include ActionView::Helpers::DateHelper
  acts_as_paranoid
  acts_as_tenant(:company)

  # Validation
  validates :name, :emei, :device_model_id, :device_type_id, presence: true
  validates_uniqueness_of :name, conditions: -> { where(deleted_at: nil) }, case_sensitive: false
  validates_uniqueness_of :emei, conditions: -> { where(deleted_at: nil) }, case_sensitive: false

  # Scopes
  scope :by_device_model, -> device_model_id { where(:device_model_id => device_model_id) }
  scope :by_device_type, -> device_type_id { where(:device_type_id => device_type_id) }
  scope :with_simcard, -> { where("id IN (SELECT device_id FROM Simcards WHERE device_id IS NOT NULL)") }
  scope :without_simcard, -> { where("id NOT IN (SELECT device_id FROM Simcards WHERE device_id IS NOT NULL)") }
  scope :available, -> { where(:car_id => nil) }
  scope :used, -> { where("car_id IS NOT NULL") }
  scope :specific_car, -> (car_id) { where(car_id: car_id) }

  # Attr accessor
  attr_accessor :sim_card_id

  # ASSOCIATION
  has_one :simcard, :dependent => :nullify
  belongs_to :device_model
  belongs_to :device_type
  belongs_to :car
  belongs_to :company
  has_many :states
  has_many :locations

  # CALLBACKS
  before_destroy :destroy_traccar_device
  after_save :create_traccar_device, :assign_sim_card
  before_update :update_traccar_device


  # CLASS METHODS
  class << self
    def sync_to_traccar
      Device.all.each do |d|
        d.save! if Traccar::Device.find_by_uniqueid(d.emei).nil?
      end
    end

    def import(file)
      status = {}
      begin
        spreadsheet = open_spreadsheet(file)
        header      = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|
          row               = Hash[[header, spreadsheet.row(i)].transpose]
          device            = find_by_id(row["id"]) || new
          device.attributes = row.to_hash.slice(*accessible_attributes)
          status[:message]  = "Devices imported!"
          status[:alert]    = "success"
          device.save!
        end
      rescue => exception
        status[:message] = exception
        status[:alert]   = "danger"
      end

      status
    end

    def open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" 
        Csv.new(file.path, nil, :ignore)
      when ".xls" 
        Excel.new(file.path, nil, :ignore)
      when ".xlsx" 
        Excelx.new(file.path, nil, :ignore)
      else 
        raise "Unknown file type: #{file.original_filename}"
      end
    end

    def available_devices
      Device.where(:car_id => nil)
    end

    def without_simcards(device_id)
      if device_id.present?
        Device.where("id NOT IN (SELECT device_id FROM simcards WHERE device_id IS NOT NULL) OR id = #{device_id}")
      else
        Device.where("id NOT IN (SELECT device_id FROM simcards WHERE device_id IS NOT NULL)")
      end
    end
  end

  # INSTANCE METHOD
  def destroy_traccar_device
    self.traccar_device.destroy if traccar_device
  end

  def create_traccar_device
    traccar_device = Traccar::Device.find_or_create_by(name: self.name, uniqueid: self.emei)

    # ASSIGN USERS TO DEVICE
    traccar_device.users << Traccar::User.where(:name => "admin", :email => "admin")
  end

  def assign_sim_card
    Simcard.find(sim_card_id).update(device_id: id) if sim_card_id
  end

  def update_traccar_device
    traccar_device = Traccar::Device.where(uniqueid: self.emei).first

    traccar_device.update_attributes(name: self.name, uniqueid: self.emei) if traccar_device
  end

  def has_car?
    car_id.present?
  end

  def has_simcard?
    simcard.present?
  end

  def last_position
    # self.try(:traccar_device).try(:last_position)
    self.locations.last
  end

  def last_positions(number=2)
    traccar_device.last_positions(number) if traccar_device
  end

  def positions
    traccar_device.positions if traccar_device
  end

  # check if the device is reporting that the car is moving (or not)
  def moving?(precision = 0.0001)
    last_positions = self.last_positions(2).to_a
    last_state    = self.states.last

    if last_positions.count == 2
      latitude1  = last_positions[0].latitude
      longitude1 = last_positions[0].longitude
      latitude2  = last_positions[1].latitude
      longitude2 = last_positions[1].longitude
      threshold  = precision
      
      Time.use_zone('UTC') do
        if (latitude1 - latitude2).abs < threshold
          self.update_attributes(movement: false, last_checked: Time.zone.now)
          false
        else
          self.update_attributes(movement: true, last_checked: Time.zone.now)
          true
        end
      end
    else
      false
    end
  end

  def no_data?
    last_position = self.traccar_device.positions.last

    return true if last_position.nil?

    seconds = Time.zone.now - last_position.fixTime.in_time_zone

    seconds >= 20.minutes ? true : false
  end

  # return the speed of the vehicle associated with the last position
  def speed
    traccar_device.try(:positions).try(:last).try(:speed)
  end

  def traccar_device
    Traccar::Device.where(uniqueid: self.emei).first
  end
end
