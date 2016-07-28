# == Schema Information
#
# Table name: alarms
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#  deleted_at  :datetime
#

class Alarm < ActiveRecord::Base
  # INIT GEM HERE
  acts_as_paranoid

  # ASSOCIATION GOES HERE
  #alarms -> rules
  has_many :alarm_rules
  has_many :rules, through: :alarm_rules
  has_many :alarm_notifications

  #alarms -> groups
  # has_many :group_alarms
  # has_and_belongs_to_many :groups

  #alarms -> cars
  # has_and_belongs_to_many :cars
  # has_many :car_alarms

  # VALIDATION GOES HERE
  validates :name, presence: true

  # NESTED ATTR GOES HERE
  accepts_nested_attributes_for :alarm_rules, :reject_if => :all_blank, :allow_destroy => true

  # Callback
  before_create :update_param_conjuction

  # Attr accessor
  attr_accessor :rule

  def update_param_conjuction
    binding.pry
  end

  # INSTANCE METHOD GOES HERE
  def verify(car_id)
    p "car_id = #{car_id}"

    trigger_alarm = false

    # Go through rules associated with this alarm
    self.rules.all.each do |rule|

      p "rule =>"
      p rule

      p "alarm =>"
      p self

      conj = AlarmRule.where(rule_id: rule.id, alarm_id: self.id).first.conjunction
      result = rule.verify(self.id, car_id)

      p "result =>"
      p result

      if conj.nil? || conj.downcase == "or"
        trigger_alarm = trigger_alarm || result
      elsif conj.downcase == "and"
        trigger_alarm = trigger_alarm && result
      end

    end

    trigger_alarm
  end
end
