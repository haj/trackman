class Alarm < ActiveRecord::Base
	
	#alarms -> rules
	has_and_belongs_to_many :rules
	has_many :alarm_rules

	#alarms -> groups
	has_many :group_alarms
	has_and_belongs_to_many :groups
	
	#alarms -> cars
	has_and_belongs_to_many :cars
	has_many :car_alarms

	accepts_nested_attributes_for :rules, :reject_if => :all_blank, :allow_destroy => true

	def verify(car_id)

		verification_result = false

		# get rules associated with this rule 
		self.rules.all.each do |rule|

			conj = AlarmRule.where(rule_id: rule.id, alarm_id: self.id).first.conjunction
			result = rule.verify(self.id, car_id)

			if conj.nil? || conj == "or"
				verification_result = verification_result || result
			elsif conj == "and"
				verification_result = verification_result && result
			end

		end

		return verification_result

	end
	
end
