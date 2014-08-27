# == Schema Information
#
# Table name: cars
#
#  id              :integer          not null, primary key
#  mileage         :float
#  numberplate     :string(255)
#  car_model_id    :integer
#  car_type_id     :integer
#  registration_no :string(255)
#  year            :integer
#  color           :string(255)
#  group_id        :integer
#  created_at      :datetime
#  updated_at      :datetime
#  company_id      :integer
#

class Car < ActiveRecord::Base

	acts_as_messageable

	# Scopes

		scope :by_car_model, -> car_model_id { where(:car_model_id => car_model_id) }
		scope :by_car_type, -> car_type_id { where(:car_type_id => car_type_id) }
		scope :traceable, -> { where("id IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL)") }
		scope :untraceable, -> { where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL)") }
		scope :with_driver, -> { where("id IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)") }
		scope :without_driver, -> { where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)") }

	acts_as_tenant(:company)

 	# Associations

		belongs_to :company
		belongs_to :car_model
		belongs_to :car_type
		has_one :device
		has_one :driver, :class_name => "User", :foreign_key => "car_id"
		has_many :states

		#has_many :work_hours
		belongs_to :work_schedule

		belongs_to :group
		has_and_belongs_to_many :alarms
		has_many :alarm_cars

	accepts_nested_attributes_for :alarms


	# Virtual attributes

		def name
			if self.id.nil?
				return "Car"
			else
				return "##{id} - #{self.car_model.name} - #{self.car_type.name}"
			end
		end

	# Cars for devices 

		def self.cars_without_devices(car_id)
			if car_id.nil?
				Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL)")
			else
				Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL AND car_id != #{car_id})")
			end
		end

		def self.cars_without_drivers(car_id)
			if car_id.nil?
				Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)")
			else
				Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL AND car_id != #{car_id})")
			end
		end

	# Positions
		
		def self.all_positions(cars)
			
			positions = Array.new

			cars.each do |car|
	      		if !car.last_position.nil? 
	        		positions << car.last_position
	      		end
	    	end

	    	return positions
		end

		# Generate a hash with latitude and longitude of the car (fetched through the device GPS data)
		#   Also for this hash to be non-empty, the car must have a device associated with it in the database
		def last_position
			if !self.device.nil?
				return self.device.last_position
			end
		end

		def positions
			if self.device.nil?
				# if this car doesn't have a device attached to it 
				#   then just send an empty hash for the position
				return Hash.new
			else
				self.device.traccar_device.positions.order("time DESC")
			end
		end


		def positions_between_dates(user_dates)

			start_date = Time.zone.parse("#{user_dates[:start_date]} #{user_dates[:start_time]}")
			end_date = Time.zone.parse("#{user_dates[:end_date]} #{user_dates[:end_time]}")

			if user_dates[:limit_results].to_i == 0 
				user_dates[:limit_results] = 20
			end

		 	# logger.warn Time.zone
			# logger.warn "last position : #{Traccar::Position.last.created_at}"
			# logger.warn "end date : #{end_date.to_s(:db)}"
			return self.device.traccar_device.positions.where("created_at > ? AND created_at < ?", start_date.to_s(:db), end_date.to_s(:db)).order("time DESC").take(user_dates[:limit_results].to_i)

		end

		def positions_between_dates_with_default

			if Time.zone.now.hour < 6
				user_dates = {
				            :start_date => "#{Time.zone.now.day - 1}/#{Time.zone.now.month}/#{Time.zone.now.year}", 
				            :start_time => "06:00", 
				            :end_date => "#{Time.zone.now.day}/#{Time.zone.now.month}/#{Time.zone.now.year}", 
				            :end_time => "#{Time.zone.now.hour}:#{Time.zone.now.min} ", 
				            :limit_results => "100"
				          }
			else
				user_dates = {
				            :start_date => "#{Time.zone.now.day}/#{Time.zone.now.month}/#{Time.zone.now.year}", 
				            :start_time => "06:00", 
				            :end_date => "#{Time.zone.now.day}/#{Time.zone.now.month}/#{Time.zone.now.year}", 
				            :end_time => "#{Time.zone.now.hour}:#{Time.zone.now.min} ", 
				            :limit_results => "100"
				          }

			end

			start_date = Time.zone.parse("#{user_dates[:start_date]} #{user_dates[:start_time]}")
			end_date = Time.zone.parse("#{user_dates[:end_date]} #{user_dates[:end_time]}")

			if user_dates[:limit_results].to_i == 0 
				user_dates[:limit_results] = 20
			end

			return self.device.traccar_device.positions.where("created_at > ? AND created_at < ?", start_date.to_s(:db), end_date.to_s(:db)).order("time DESC").take(user_dates[:limit_results].to_i)
			
		end

	# Has?

		def has_device?
			return !self.device.nil?
		end

		def has_driver?
			return !self.driver.nil?
		end

		def has_group?
			return !self.group.nil?
		end

	# Rule accessors

		# fetch name of the rule associated with this car
		def alarm_status(alarm)
			self.car_alarms.where(alarm_id: rule.id, car_id: self.id).first.status
		end

		# fetch last_alert time of the rule associated with this car
		def alarm_last_alert(alarm)
			self.car_alarms.where(alarm_id: rule.id, car_id: self.id).first.last_alert
		end

	# Alarms

		# Verificators 

			# return if the car is moving or not 
			def moving?
				if self.no_data?
					return false
				else
					return self.device.moving?
				end
			end

			# return if the we're receiving data or not from the car
			def no_data?
				# check if last time a new position reported is longer than x minutes
				return !self.has_device? || self.device.no_data?
			end

			def speed
				self.device.speed
			end

		# Alarms trigger

			def check_alarms
				self.alarms.all.each do |alarm|
					result = alarm.verify(self.id)
					if result == true
						AlarmNotification.create(alarm_id: alarm.id, car_id: self.id)
						subject =  "Alarm : #{alarm.name}"
						body = alarm.name
						self.company.users.first.notify(subject, body, self)
						#send email to user with name of the alarm triggered
						#AlarmMailer.alarm_email(self.company.users.first, self, alarm).deliver
					end
				end

				# capture the current car state
				self.capture_state
			end

		# Generate state card
			def capture_state
				state = State.new
				state.moving = self.moving? 
				state.no_data = self.no_data?
				state.speed = self.speed
				state.car_id = self.id 
				state.driver_id = self.driver.id if self.has_driver?
				state.device_id = self.device.id if self.has_device?
				state.save!
			end











end
