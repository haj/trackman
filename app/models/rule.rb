# == Schema Information
#
# Table name: rules
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  method_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

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
			return self.send(self.method_name, car_id, eval(params))
		end

	### Rules/Triggers

		# Vehicle stopped sending updates for at least params["duration"] minutes
		def no_data?(car_id, params)
			car = Car.find(car_id)
			# check if last time a new position reported was longer than x minutes
			return !car.has_device? || car.device.no_data?(params["duration"].to_i)
		end

		# Vehicle started moving
		def starts_moving(car_id, params)
			@car = Car.find(car_id)
			return Alarm::Movement.evaluate(@car, self)
		end

		# Vehicle stopped for more than params["threshold"] minutes
		def stopped_for_more_than(car_id, params)

			# this represent to which point in time we'll go back to look if car stopped for more than X minutes
			scope = params["threshold"].to_i*2

			# if a previous alarm of this type was triggered, then cancel this one
			if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, params["threshold"].to_i.minutes.ago).count != 0
				Rails.logger.debug "[stopped_for_more_than] RETURNED [FALSE] FOR #{car_id} BECAUSE OF [RuleNotification]"
				return false
			end

			states = Car.find(car_id).states.where(" created_at >= ? " , scope.minutes.ago).where(:no_data => false).order("created_at ASC")
			
			# let's consider duration_threshold to be X, then the user is looking if the car stopped for more than X minutes.  
			duration_threshold = params["threshold"].to_i

			#puts states.count
			previous_state = states.first


			# How it works : 
			# Basically we'll start with the first state where the car wasn't moving, and keep iterating over states and updating duration_sum
			# as long as the next state represent the car in a stopped state. 
			# we'll stop if we go over the duration_threshold, in that case, the car stopped for more than the threshold
			# also if we while iterating over states we find that the car started moving again, then we bring duration_sum back to zero
			# and keep iterating until we hit a state where the car stopped again, and then we try to see if duration_sum could go over the duration_threshold
			# we do this in a loop until we go over all states. 
			# 

			duration_sum = 0 
			states.each do |car_current_state| 
				if car_current_state.moving == false #this means car wasn't moving at the moment
					# we calculate how much time between the two states
					duration_sum += (car_current_state.created_at  - previous_state.created_at)/60

					# we check if that time is considered greater than the threshold the user set through duration_threshold
					if duration_sum >= duration_threshold
						RuleNotification.create(rule_id: self.id, car_id: car_id)
						return true
					end
				else #this means car started moving again
					duration_sum = 0
				end
				previous_state = car_current_state
			end
			return false
		end

		# Vehicle driving for more than consecutive params["threshold"] (duration) minutes
		def driving_consecutive_hours(car_id, params)

			# This is how much in time we'll go to back when looking if car stopped or not.
			# basically if user is looking if car stopped for more than 15 minutes, scope would be 30 minuts, 
			# which means we'll check if the car stopped for more than 15 minutes in the last 30 minutes just to be sure! 
			scope = params["threshold"].to_i*2

			# We check if this particular alarm was triggered before, if so then no need to re-trigger it, which means no need to check
			if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, params["threshold"].to_i.minutes.ago).count != 0
				return false
			end

			# How it works : 
			# 
			# Basically we'll start with the first state where the car was moving, and keep iterating over states and updating duration_sum
			# as long as the next state represent the car in a moving state. 
			# we'll stop if we go over the duration_threshold, in that case, the car was moving for more than the X minutes or the threshold
			# also if while iterating over states we find that the car stopped moving again, then we bring duration_sum back to zero
			# and keep iterating until we hit a state where the car started moving again, and then we try to see if duration_sum could go over the duration_threshold
			# we do this in a loop until we go over all states. That's it! 
			# 

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
			if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id,  params['repeat_notification'].to_i.minutes.ago).count != 0 || car.no_data?
				return false
			end

			if car.device.speed > params["speed"].to_i # in km/h
				RuleNotification.create(rule_id: self.id, car_id: car_id)
				return true
			else
				return false
			end
		end

		# Vehicle moving during (or not) work hours
		def movement_not_authorized(car_id, params)

			# setup the car we can apply this rule to
			car = Car.find(car_id)

			# else we can proceed to check if car moving outside work hours
			last_position = car.positions.where("created_at > ?", 5.minutes.ago).last

			# if we raised an alarm like this in the last 30 minutes, then we don't have to raise another one again, so no need to even check if it's true
			if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, params["repeat_notification"].to_i.minutes.ago).count != 0 || last_position.nil? || car.work_schedule.nil?
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
				RuleNotification.create(rule_id: self.id, car_id: car_id)
				return true
			end

			
				
		end


		# This will check if vehicle entered a particular area
		# Basically this will check first if the vehicle was outside the area, and if it's currently inside the selected area
		def enter_area(car_id, params)

			car = Car.find(car_id)
			current_position, previous_position = car.device.last_positions

			if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, 15.minutes.ago).count != 0 || current_position.nil?
				return false
			end

			
			region = Region.find(params["region_id"].to_i)
			car_outside = !region.contains_point(previous_position.latitude, previous_position.longitude)
			if car_outside == true
				car_inside = region.contains_point(current_position.latitude, current_position.longitude)
				if car_inside
					RuleNotification.create(rule_id: self.id, car_id: car_id)
					return true
				else
					return false
				end
			else
				return false
			end
		end

		# This will check if vehicle left a particular area
		# Basically this will check first if the vehicle was inside the area, and if it's currently outside the selected area
		def leave_area(car_id, params)

			car = Car.find(car_id)
			current_position, previous_position = car.device.last_positions

			if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, 15.minutes.ago).count != 0 || current_position.nil?
				return false
			end
			
			region = Region.find(params["region_id"].to_i)
			car_inside = region.contains_point(previous_position.latitude, previous_position.longitude)
			if car_inside == true
				car_outside = !region.contains_point(current_position.latitude, current_position.longitude)
				if car_outside == true
					RuleNotification.create(rule_id: self.id, car_id: car_id)
					return true 
				else
					return false
				end
			else
				return false
			end
		end

		# TODO : Vehicle moving outside planned route
		def left_planned_route(car_id, params)

		end

end
