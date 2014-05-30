class Rule < ActiveRecord::Base

	has_and_belongs_to_many :alarms
	has_many :alarm_rules
	has_many :parameters

	accepts_nested_attributes_for :parameters, :reject_if => :all_blank, :allow_destroy => true

	attr_accessor :stupid_field, :params

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

	def self.test(params)
		return true
	end

	# lost contact with vehicle
	# params = {:car_id, :duration}
	def no_data?(car_id, params)
		car = Car.find(car_id)
		# check if last time a new position reported is longer than x minutes
		return !car.has_device? || car.device.no_data?(params[:duration])
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
	def going_faster_than(car_id, params)
		car = Car.find(car_id)
		if car.device.speed > params[:speed] # in km/h
			Rails.logger.info "[going_faster_than] Car going faster than #{params[:speed]}"
			return true
		else
			Rails.logger.info "[going_faster_than] Car going slower than #{params[:speed]}"
			return false
		end	
	end

	# going too slow
	def going_slower_than(car_id, params)
		car = Car.find(car_id)

		if car.device.speed <= params[:speed] # in km/h
			return true
		else
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



end
