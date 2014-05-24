class Group < ActiveRecord::Base
	has_many :cars
	acts_as_tenant(:company)

	has_and_belongs_to_many :rules
	has_many :group_rules

	def rule_status(rule)
		self.group_rules.where(rule_id: rule.id, group_id: self.id).first.status
	end

	def rule_last_alert(rule)
		self.group_rules.where(rule_id: rule.id, group_id: self.id).first.last_alert
	end
	
end
