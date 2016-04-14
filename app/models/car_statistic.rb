class CarStatistic < ActiveRecord::Base
  belongs_to :car
  after_initialize :init

  def init
    self.tdistance ||= 0.0
    self.tdrivtime ||= 0
    self.tparktime ||= 0
    self.maxspeed ||= 0.0
    self.avgspeed ||= 0.0
  end

end
