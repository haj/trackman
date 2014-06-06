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

	has_and_belongs_to_many :alarms
	has_many :alarm_rules
	has_many :parameters

	accepts_nested_attributes_for :parameters, :reject_if => :all_blank, :allow_destroy => true

	attr_accessor :params

	def params
		self.parameters
	end



	def verify(alarm_id, car_id)
		# get params
		alarm_rule = AlarmRule.where(alarm_id: alarm_id, rule_id: self.id).first
		params = alarm_rule.params

		# TODO : make the eval more secure
		result = self.send(self.method_name, car_id, eval(params))

		#Rails.logger.info "[rule#verify] #{self.name} is #{result}"

		return result
	end

	# lost contact with vehicle
	# params = {:car_id, :duration}
	def no_data?(car_id, params)
		car = Car.find(car_id)
		# check if last time a new position reported is longer than x minutes
		return !car.has_device? || car.device.no_data?(params["duration"].to_i)
	end

	# starts moving
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

	# long pause
	def stopped_for_more_than(car_id, params)
		car = Car.find(car_id)

		states = car.states.where(created_at > params["time_scope"].to_i.minutes.ago).order("created_at DESC")

		duration_threshold = params["duration"].to_i

		previous_state = states.first

		states.each do |current_state| 

			if current_state.movement == false #car not moving
				duration_sum = 0 if current_state.created_at != previous_state.created_at && previous_state.movement == true
				duration_sum += (previous_state.created_at - current_state.created_at)/60
				if duration_sum >= duration_threshold
					return true
				end
			end

			previous_state = current_state
		end

		return false

	end

	# not respecting speed limits
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

	# going too slow
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

	# check if the car is moving during work hours
	def movement_authorized(car_id, params)

		car = Car.find(car_id)

		current_time = Time.now.to_time_of_day
		current_day_of_week = Time.now.wday

		car.work_hours.each do |work_hour|
			shift = Shift.new(work_hour.starts_at, work_hour.ends_at)
			if shift.include?(current_time) && work_hour.day_of_week == current_day_of_week
				return true
			end
		end

		return false
	end

	def drove_for_more_than(car_id, params)
	end



end
