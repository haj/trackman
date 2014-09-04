class Alarm::Movement

	def self.evaluate(car, rule)
		if RuleNotification.where("rule_id = ? AND created_at >= ?", rule.id, 5.minutes.ago).count != 0
			false
		elsif  Alarm::Movement.vehicle_stopped(car) && car.device.moving?
			true
		else
			false
		end
	end

	def self.vehicle_stopped(car)

		if car.states.count == 0
			true
		else
			states = car.states.where(" created_at >= ? " , 10.minutes.ago).where(:no_data => false).order("created_at ASC")
			previous_state = states.first
			duration_sum = 0 
			states.each do |car_current_state| 
				if car_current_state.moving == false #car not moving
					duration_sum += ( car_current_state.created_at  - previous_state.created_at)/60
					if duration_sum >= 5
						true
					end
				else #car started moving again
					duration_sum = 0
				end
				previous_state = car_current_state
			end
			return false
		end
		
	end

end
