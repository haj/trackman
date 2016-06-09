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
  # ASSOCIATION
  belongs_to :car
  belongs_to :last_start, :class_name => "Location"
  belongs_to :last_stop, :class_name => "Location"
  belongs_to :last_is, :class_name => "Location"

  # CALLBACK
  after_initialize :init

  # INSTANCE METHOD
  def init
    self.tdistance ||= 0.0
    self.tdrivtime ||= 0
    self.tparktime ||= 0
    self.maxspeed ||= 0.0
    self.avgspeed ||= 0.0
    self.steps_counter ||= 0
  end

  def last_is_start?
    if self.last_is.try(:state) == "start"
      true
    else
      false
    end
  end

  def last_is_stop?
    !last_is_start? && !self.last_is.try(:state).nil?
  end
end
