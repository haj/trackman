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

			states = car.states.where(" created_at > ? " , params["scope"].to_i.minutes.ago).where(:no_data => false).order("created_at ASC")

			duration_threshold = params["threshold"].to_i

			
			puts states.count

			previous_state = states.first
			duration_sum = 0 

			states.each do |car_current_state| 

				if car_current_state.moving == false #car not moving
					duration_sum += ( car_current_state.created_at  - previous_state.created_at)/60
					if duration_sum >= duration_threshold
						puts "final duration_sum : #{duration_sum}"
						puts "final duration_threshold : #{duration_threshold}"
						return true
					end
				else #car started moving again
					duration_sum = 0
				end

				puts "duration_sum : #{duration_sum}"
				previous_state = car_current_state

			end

			puts "final duration_sum : #{duration_sum}"
			puts "final duration_threshold : #{duration_threshold}"
			return false
		end

		# TODO : Vehicle driving for more than consecutive params["duration"] minutes in the last params["time_scope"]
		#  
		def driving_consecutive_hours(car_id, params) # params = {time_scope, duration}
			car = Car.find(car_id)

			# get states created in the last X minutes
			states = car.states.where("created_at > ?" , params["scope"].to_i.minutes.ago).where(:no_data => false).order("created_at ASC")

			duration_threshold = params["threshold"].to_i #in minutes

			previous_state = states.first
			duration_sum = 0 

			states.each do |car_current_state| 
				if car_current_state.moving == true #car is moving
					
					duration_sum += (car_current_state.created_at  - previous_state.created_at)/60 #convert to minutes
					
					puts "duration_sum : #{duration_sum}"
					puts "duration_threshold : #{duration_threshold}"


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

		# Vehicle enters an area 
		def entered_an_area(car_id, params)

			# Get the current coordinate of the car
			car = Car.find(car_id)

			current_position, previous_position = car.device.last_positions

			# TODO : put real region
			region = Region.find(params["region_id"].to_i)

			car_outside = !region.contains_point(previous_position.latitude, previous_position.longitude)

			if car_outside == true

				car_inside = region.contains_point(current_position.latitude, current_position.longitude)

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

		# Vehicle leaves an area
		def left_an_area(car_id, params)
		
			# get the current coordinate of the car
			car = Car.find(car_id)

			current_position, previous_position = car.device.last_positions

			# TODO : put real region
			region = Region.find(params["region_id"].to_i)

			car_inside = region.contains_point(previous_position.latitude, previous_position.longitude)

			if car_inside == true

				car_outside = !region.contains_point(current_position.latitude, current_position.longitude)

				if car_outside == true
					Rails.logger.info "[left_an_area] car_outside = true"
					return true#, "[left_an_area] car_outside = true"
				else
					Rails.logger.info "[left_an_area] car_outside = false"
					return false#, "[left_an_area] car_outside = false"
				end
				
			else
				Rails.logger.info "[left_an_area] car_inside = false"
				return false#, "[left_an_area] car_inside = false"
			end
		end

		# TODO : Vehicle outside planned route
		def left_planned_route(car_id, params)

		end

		def self.test_method

			Rule.destroy_all
			Car.destroy_all
			Device.destroy_all
			Region.destroy_all
			Vertex.destroy_all
			Alarm.destroy_all
			AlarmRule.destroy_all
			Traccar::Position.destroy_all
			Traccar::Device.destroy_all


			# create rule + parameter for leaving area
			rule = Rule.create!(name: "Left area", method_name: "left_an_area")
			Parameter.create!(name: "region_id", data_type: "integer", rule_id: rule.id)

			# Create Car, Device, Traccar::Device
			car = Car.create!(numberplate: "44444")
			
			device = Device.create!(name: "Device", emei: "44444", car_id: car.id)
			traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")

			# Create region with vertices 
			region = Region.create!(name: "Statue of Liberty")
			Vertex.create!([
				{latitude: 40.69121432764299, longitude: -74.0477442741394, region_id: region.id},
				{latitude: 40.68931071707278, longitude: -74.04714345932007, region_id: region.id},
				{latitude: 40.688480921087525, longitude: -74.04557704925537, region_id: region.id},
				{latitude: 40.68838329735111, longitude: -74.04416084289551, region_id: region.id},
				{latitude: 40.68896903762434, longitude: -74.04300212860107, region_id: region.id},
				{latitude: 40.690368285214454, longitude: -74.04360294342041, region_id: region.id},
				{latitude: 40.69121432764299, longitude: -74.04600620269775, region_id: region.id}
			])

			# create new alarm
			alarm = Alarm.create!(name: "Car Left the Statue of liberty area")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'region_id'=>'#{region.id}'}")
			car.alarms << alarm

			# simulate being inside that area
			liberty_statue = { :latitude => 40.689249, :longitude => -74.0445 }
	  		inside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: liberty_statue[:latitude], longitude: liberty_statue[:longitude], other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: traccar_device.id)
	  		traccar_device.positions << inside_position
	  		traccar_device.save!
	  		# simulate being outside
			outside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: traccar_device.id)
	  		traccar_device.positions << outside_position
	  		traccar_device.save!

	  		Rule.first.left_an_area(car.id, { "region_id" => region.id })
		end



end
