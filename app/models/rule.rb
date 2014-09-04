class Rule < ActiveRecord::Base

	has_and_belongs_to_many :alarms
	has_many :alarm_rules
	has_many :parameters

	accepts_nested_attributes_for :parameters, :reject_if => :all_blank, :allow_destroy => true

	attr_accessor :params

	# Virtual attributes

		def params
			self.parameters
		end

		def verify(alarm_id, car_id)
			alarm_rule = AlarmRule.where(alarm_id: alarm_id, rule_id: self.id).first
			params = alarm_rule.params
			self.send(self.method_name, car_id, eval(params))
		end

	### Triggers

		# Vehicle stopped sending updates for at least params["duration"] minutes
		def no_data?(car_id, params)
			car = Car.find(car_id)
			# check if last time a new position reported was longer than x minutes
			return !car.has_device? || car.device.no_data?(params["duration"].to_i)
		end

		# Vehicle started moving
		def starts_moving(car_id, params)
			if RuleNotification.where("rule_id = ? AND created_at >= ?", self.id, 5.minutes.ago).count != 0
				false
			elsif Rule.where(method_name: "stopped_for_more_than").first.stopped_for_more_than(car_id, { 'threshold' => '15' }) && car.device.moving?
				true
			else
				false
			end
		end

		# Vehicle stopped for more than params["duration"] minutes in the last params["time_scope"] minutes
		def stopped_for_more_than(car_id, params)

			scope = params["threshold"].to_i*2

			# if a previous alarm of this type was triggered, then cancel this one
			if RuleNotification.where("rule_id = ? AND created_at >= ?", self.id, params["threshold"].to_i.minutes.ago).count != 0
				return false
			end

			states = Car.find(car_id).states.where(" created_at >= ? " , scope.minutes.ago).where(:no_data => false).order("created_at ASC")
			duration_threshold = params["threshold"].to_i
			puts states.count
			previous_state = states.first
			duration_sum = 0 
			states.each do |car_current_state| 
				if car_current_state.moving == false #car not moving
					duration_sum += ( car_current_state.created_at  - previous_state.created_at)/60
					if duration_sum >= duration_threshold
						RuleNotification.create(rule_id: self.id, car_id: car_id)
						return true
					end
				else #car started moving again
					duration_sum = 0
				end
				previous_state = car_current_state
			end
			return false
		end

		# Vehicle driving for more than consecutive params["threshold"] (duration) minutes in the last params["scope"] (time_scope)
		def driving_consecutive_hours(car_id, params)

			scope = params["threshold"].to_i*2

			if RuleNotification.where("rule_id = ? AND created_at >= ?", self.id, params["threshold"].to_i.minutes.ago).count != 0
				return false
			end

			states = Car.find(car_id).states.where("created_at > ?" , scope.minutes.ago).where(:no_data => false).order("created_at ASC")
			duration_threshold = params["threshold"].to_i #in minutes
			previous_state = states.first
			duration_sum = 0 
			states.each do |car_current_state| 
				if car_current_state.moving == true #car is moving
					duration_sum += (car_current_state.created_at  - previous_state.created_at)/60 #convert to minutes
					if duration_sum >= duration_threshold
						RuleNotification.create(rule_id: self.id, car_id: car_id)
						return true
					end
				else #car stopped moving
					duration_sum = 0
				end
				previous_state = car_current_state
			end
			return false
		end

		# Vehicle moving faster than params["speed"]
		def speed_limit(car_id, params)
			car = Car.find(car_id)
			if car.no_data?
				return false
			elsif car.device.speed > params["speed"].to_i # in km/h
				return true
			else
				return false
			end	
		end

		# NOT TESTED/ NOT ACTIVE 
		# Vehicle moving slower than params["speed"]
		def going_slower_than(car_id, params)
			car = Car.find(car_id)

			if car.device.speed <= params["speed"].to_i # in km/h
				return true
			else
				return false
			end	
		end

		# Vehicle moving during (or not) work hours
		def movement_not_authorized(car_id, params)

			# setup the car we can apply this rule to
			car = Car.find(car_id)

			# if we raised an alarm like this in the last 30 minutes, then we don't have to raise another one again, so no need to even check if it's true
			if RuleNotification.where("rule_id = ? AND created_at >= ?", self.id, 30.minutes.ago).count != 0
				return false
			end

			# else we can proceed to check if car moving outside work hours
			last_position = car.positions.where("created_at > ?", 5.minutes.ago).last

			if last_position.nil? 
				#if there was no movement in the last 5 minutes then we probably have a problem bigger than if the vehicle is moving during work hours or not
				return false
			else 
				current_time = last_position.created_at.to_time_of_day
				current_day_of_week = last_position.created_at.wday
				current_day_of_week = 7 if current_day_of_week == 0 
				car.work_schedule.work_hours.each do |work_hour|
					shift = Shift.new(work_hour.starts_at, work_hour.ends_at)
					if shift.include?(current_time) && work_hour.day_of_week == current_day_of_week
						return false
					end
				end
				return true
			end

			
				
		end

		def enter_area(car_id, params)
			car = Car.find(car_id)
			current_position, previous_position = car.device.last_positions
			region = Region.find(params["region_id"].to_i)
			car_outside = !region.contains_point(previous_position.latitude, previous_position.longitude)
			if car_outside == true
				car_inside = region.contains_point(current_position.latitude, current_position.longitude)
				if car_inside
					return true
				else
					return false
				end
			else
				return false
			end
		end

		def leave_area(car_id, params)
			car = Car.find(car_id)
			current_position, previous_position = car.device.last_positions
			region = Region.find(params["region_id"].to_i)
			car_inside = region.contains_point(previous_position.latitude, previous_position.longitude)
			if car_inside == true
				car_outside = !region.contains_point(current_position.latitude, current_position.longitude)
				if car_outside == true
					return true 
				else
					return false
				end
			else
				return false
			end
		end

		# TODO : Vehicle outside planned route
		def left_planned_route(car_id, params)

		end

end
