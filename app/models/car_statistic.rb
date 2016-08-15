# == Schema Information
#
# Table name: car_statistics
#
#  id            :integer          not null, primary key
#  car_id        :integer
#  time          :datetime
#  tparktime     :integer
#  tdrivtime     :integer
#  maxspeed      :float(24)
#  avgspeed      :float(24)
#  tdistance     :float(24)
#  steps_counter :integer
#  last_start_id :integer
#  last_stop_id  :integer
#  last_is_id    :integer
#

class CarStatistic < ActiveRecord::Base
  # Init Gem
  include AASM

  aasm do
    state :stop, :initial => true
    state :onroad, :start

    event :run do
      transitions :from => [:start, :onroad], :to => :onroad
    end

    event :park do
      transitions :from => [:start, :onroad], :to => :stop
    end

    event :new_start do
      transitions :from => :stop, :to => :start
    end
  end

  # ASSOCIATION
  belongs_to :car
  belongs_to :last_start, :class_name => "Location"
  belongs_to :last_stop, :class_name => "Location"
  belongs_to :last_is, :class_name => "Location"

  # CALLBACK
  after_initialize :init

  # validation
  validates :car_id, presence: true

  # SCOPE
  scope :car_date, -> (car_id, date) { where(car_id: car_id, time: date) }

  # INSTANCE METHOD
  def init
    self.tdistance     ||= 0.0
    self.tdrivtime     ||= 0
    self.tparktime     ||= 0
    self.maxspeed      ||= 0.0
    self.avgspeed      ||= 0.0
    self.steps_counter ||= 0
  end

  def last_is_start?
    self.last_is.try(:state) == "start"
  end

  def last_is_stop?
    !last_is_start? && !self.last_is.try(:state).nil?
  end
end
