class CarStatistic < ActiveRecord::Base
  belongs_to :car
  belongs_to :last_start, :class_name => "Location"
  belongs_to :last_stop, :class_name => "Location"
  belongs_to :last_is, :class_name => "Location"
  after_initialize :init

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
    !last_is_start?
  end

end
