class Rule < ActiveRecord::Base

	has_and_belongs_to_many :alarms
	has_many :alarm_rules


	def verify(alarm_id)
		# get params
		alarm_rule = AlarmRule.where(alarm_id: alarm_id, rule_id: self.id).first
		params = alarm_rule.params

		return self.send(self.method_name, eval(params))
	end

	def self.test(params)
		return true
	end

	# lost contact with vehicle
	# params = {:car_id, :duration}
	def no_data?(params)
		car = Car.find(params[:car_id])
		# check if last time a new position reported is longer than x minutes
		return !car.has_device? || car.device.no_data?(params[:duration])
	end

	# starts moving
	def starts_moving(params)
		car = Car.find(params[:car_id])
		if car.no_data?
			return false
		else
			return car.device.moving?
		end
	end

	# long pause
	def stopped_for_more_than(params)
		car = Car.find(params[:car_id])

		states = car.states.where(created_at > params[:duration]).order("created_at DESC")

		# find first state where movement => true and speed > 5 in that 2 hours window
		states_where_vehicle_was_moving = states.select { |state| state.movement == true && state.speed > 5 }

		if states_where_vehicle_was_moving.count > 0
			return false
		else 
			return true
		end
	end

	# not respecting speed limits
	def going_faster_than(params)
		car = Car.find(params[:car_id])
		if car.device.speed > params[:speed] # in km/h
			return true
		else
			return false
		end	
	end

	# going too slow
	def going_slower_than(params)
		car = Car.find(params[:car_id])

		if car.device.speed <= params[:speed] # in km/h
			return true
		else
			return false
		end	
	end



end
