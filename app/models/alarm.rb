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

	validates :name, presence: true

	acts_as_paranoid

	#alarms -> rules
	has_and_belongs_to_many :rules
	has_many :alarm_rules

	has_many :alarm_notifications

	#alarms -> groups
	# has_many :group_alarms
	# has_and_belongs_to_many :groups

	#alarms -> cars
	# has_and_belongs_to_many :cars
	# has_many :car_alarms

	accepts_nested_attributes_for :rules, :reject_if => :all_blank, :allow_destroy => true

	def verify(car_id)

		trigger_alarm = false

		# Go through rules associated with this alarm
		self.rules.all.each do |rule|

			conj = AlarmRule.where(rule_id: rule.id, alarm_id: self.id).first.conjunction
			result = rule.verify(self.id, car_id)

			if conj.nil? || conj.downcase == "or"
				trigger_alarm = trigger_alarm || result
			elsif conj.downcase == "and"
				trigger_alarm = trigger_alarm && result
			end

		end

		return trigger_alarm

	end

end
