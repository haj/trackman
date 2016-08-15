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
  has_many :rules, through: :alarm_rules
  has_many :alarm_rules
  has_many :alarm_notifications
  has_many :alarm_cars
  has_many :cars, through: :alarm_cars

  #alarms -> groups
  # has_many :group_alarms
  # has_and_belongs_to_many :groups

  # VALIDATION GOES HERE
  validates :name, presence: true

  # NESTED ATTR GOES HERE
  accepts_nested_attributes_for :alarm_rules, :reject_if => :all_blank, :allow_destroy => true
end
