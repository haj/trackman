# == Schema Information
#
# Table name: rules
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  method_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Rule < ActiveRecord::Base

	# Associations

		has_and_belongs_to_many :alarms
		has_many :alarm_rules
		has_many :parameters

	accepts_nested_attributes_for :parameters, :reject_if => :all_blank, :allow_destroy => true

	attr_accessor :params

	# Virtual attributes

		def params
			self.parameters
		end

	# Check if a certain rule (+params) apply to a specific car 
	def verify(alarm_id, car_id)
		# get params
		alarm_rule = AlarmRule.where(alarm_id: alarm_id, rule_id: self.id).first
		params = alarm_rule.params

		# TODO : make the eval more secure
		result = self.send(self.method_name, car_id, eval(params))

		#Rails.logger.info "[rule#verify] #{self.name} is #{result}"

		return result
	end

	### Verificators

		# Vehicle stopped sending updates for at least params["duration"] minutes
		def no_data?(car_id, params)
			car = Car.find(car_id)
			# check if last time a new position reported is longer than x minutes
			return !car.has_device? || car.device.no_data?(params["duration"].to_i)
		end

		# Vehicle started moving
		def starts_moving(car_id, params)
			car = Car.find(car_id)
			if car.no_data?
				Rails.logger.info "[starts_moving] Car has no data"
				return false
			else
				result = car.device.moving?
				Rails.logger.info "[starts_moving] Car moving is #{result}"
				return result
			end
		end

		# TODO : Vehicle stopped for more than params["duration"] minutes in the last params["time_scope"] minutes

		def stopped_for_more_than(car_id, params)
			car = Car.find(car_id)

			states = car.states.where(created_at > params["time_scope"].to_i.minutes.ago).order("created_at ASC")

			duration_threshold = params["duration"].to_i

			previous_state = states.first

			states.each do |car_current_state| 

				if car_current_state.moving == false #car not moving
					duration_sum += ( car_current_state.created_at  - previous_state.created_at)/60
					if duration_sum >= duration_threshold
						return true
					end
				else #car started moving again
					duration_sum = 0
				end

				previous_state = car_current_state

			end

			return false
		end

		# TODO : Vehicle driving for more than consecutive params["duration"] minutes in the last params["time_scope"]
		#  
		def driving_consecutive_hours(car_id, params) # params = {time_scope, duration}
			car = Car.find(car_id)
			# get states created in the last X minutes
			states = car.states.where(created_at > params["time_scope"].to_i.minutes.ago).order("created_at ASC")
			duration_threshold = params["duration"].to_i
			previous_state = states.first
			states.each do |car_current_state| 
				if car_current_state.moving == true #car is moving
					duration_sum += ( car_current_state.created_at  - previous_state.created_at)/60
					if duration_sum >= duration_threshold
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
		def going_faster_than(car_id, params)
			car = Car.find(car_id)
			if car.device.speed > params["speed"].to_i # in km/h
				Rails.logger.info "[going_faster_than] Car going faster than #{params['speed']}"
				return true
			else
				Rails.logger.info "[going_faster_than] Car going slower than #{params['speed']}"
				return false
			end	
		end

		# Vehicle moving slower than params["speed"]
		def going_slower_than(car_id, params)
			car = Car.find(car_id)

			if car.device.speed <= params["speed"].to_i # in km/h
				Rails.logger.info "[going_slower_than] Car going slower than #{params['speed']}"
				return true
			else
				Rails.logger.info "[going_slower_than] Car going faster than #{params['speed']}"
				return false
			end	
		end


		# Vehicle moving during (or not) work hours
		def movement_authorized(car_id, params, time = Time.now)

			car = Car.find(car_id)

			current_time = time.to_time_of_day

			current_day_of_week = time.wday

			if current_day_of_week == 0 
				current_day_of_week = 7
			end

			car.work_schedule.work_hours.each do |work_hour|
				shift = Shift.new(work_hour.starts_at, work_hour.ends_at)
				if shift.include?(current_time) && work_hour.day_of_week == current_day_of_week
					return true
				end
			end

			return false
		end

		# TODO : Vehicle enters an area 
		def entered_an_area(car_id, params)

			# Get the current coordinate of the car
			car = Car.find(car_id)

			current_position, previous_position = car.device.last_positions

			# TODO : put real region
			region = Region.find(params["region_id"].to_i)

			car_outside = !region.contains_point(previous_position[:latitude], previous_position[:longitude])

			if car_outside == true

				car_inside = region.contains_point(current_position[:latitude], current_position[:longitude])

				if car_inside
					Rails.logger.info "[entered_an_area] car_inside = true"
					return true
				else
					Rails.logger.info "[entered_an_area] car_inside = false"
					return false
				end
				
			else
				Rails.logger.info "[entered_an_area] car_outside = true"
				return false
			end
		end

		# TODO : Vehicle leaves an area
		def left_an_area(car_id, params)
		
			# get the current coordinate of the car
			car = Car.find(car_id)

			current_position, previous_position = car.device.last_positions

			# TODO : put real region
			region = Region.find(params["region_id"].to_i)

			car_inside = region.contains_point(previous_position[:latitude], previous_position[:longitude])

			if car_inside == true

				car_outside = !region.contains_point(current_position[:latitude], current_position[:longitude])

				if car_outside == true
					Rails.logger.info "[left_an_area] car_outside = true"
					return true
				else
					Rails.logger.info "[left_an_area] car_outside = false"
					return false
				end
				
			else
				Rails.logger.info "[left_an_area] car_inside = false"
				return false
			end
		end

		# TODO : Vehicle outside planned route
		def left_planned_route(car_id, params)

		end



end
