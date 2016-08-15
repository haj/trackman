# == Schema Information
#
# Table name: rules
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  method_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

class Rule < ActiveRecord::Base
  # ASSOCIATION
  has_many :alarms, through: :alarm_rules
  has_many :alarm_rules
  has_many :parameters

  # VALIDATION GOES HERE
  validates :name, :method_name, presence: true

  # NESTED ATTR
  accepts_nested_attributes_for :parameters, :reject_if => :all_blank, :allow_destroy => true

  # ATTR ACESSOR
  attr_accessor :params

  # Virtual attributes
  def params
    self.parameters
  end

  def verify(alarm_id, car_id)
    alarm_rule = AlarmRule.where(alarm_id: alarm_id, rule_id: self.id).first
    params     = alarm_rule.params
    
    self.send(self.method_name, car_id, params)
  end

  # Vehicle stopped sending updates for at least params["duration"] minutes
  def no_data?(car_id, params)
    car = Car.find(car_id)

    !car.has_device? || car.device.no_data?(params["duration"].to_i)
  end

  # Vehicle started moving
  def starts_moving(car_id, params)
    @car = Car.find(car_id)

    Alarm::Movement.evaluate(@car, self)
  end
end
