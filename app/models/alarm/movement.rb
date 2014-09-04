class Alarm::Movement

	def self.evaluate(car, rule)
		if RuleNotification.where("rule_id = ? AND created_at >= ?", rule.id, 5.minutes.ago).count != 0
			return false
		elsif  Alarm::Movement.vehicle_stopped(car) && car.device.moving?
			RuleNotification.create(rule_id: rule.id, car_id: car.id)
			return true
		else
			return false
		end
	end

	def self.vehicle_stopped(car)

		if car.states.count == 0
			return true
		else
			states = car.states.where(" created_at >= ? " , 10.minutes.ago).where(:no_data => false).order("created_at ASC")
			previous_state = states.first
			duration_sum = 0 
			states.each do |car_current_state| 
				if car_current_state.moving == false #car not moving
					duration_sum += ( car_current_state.created_at  - previous_state.created_at)/60
					#Rails.logger.warn "#car not moving : #{duration_sum}"
					if duration_sum >= 5
						#Rails.logger.warn "vehicle_stopped : true"
						return true
					end
				else #car started moving again
					#Rails.logger.warn "car started moving again"
					duration_sum = 0
				end
				previous_state = car_current_state
			end
			return false
		end
		
	end

end
