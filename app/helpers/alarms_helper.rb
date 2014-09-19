module AlarmsHelper

	def rule_with_params(rule, alarm)
		rule_name = rule.name 
		alarm_rule = AlarmRule.where(alarm_id: alarm.id, rule_id: rule.id).first
		params = eval(alarm_rule.params)
		if !params.nil?
			return "#{rule_name}"
		end
	end
	
end

