# == Schema Information
#
# Table name: cars
#
#  id               :integer          not null, primary key
#  mileage          :float
#  numberplate      :string(255)
#  car_model_id     :integer
#  car_type_id      :integer
#  registration_no  :string(255)
#  year             :integer
#  color            :string(255)
#  group_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  company_id       :integer
#  work_schedule_id :integer
#  name             :string(255)
#  deleted_at       :datetime
#

class Car < ActiveRecord::Base
	acts_as_paranoid
	acts_as_messageable


	# validation 

	validates :name, :numberplate, presence: true


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
		has_one :device, :dependent => :nullify
		has_one :driver, :class_name => "User", :foreign_key => "car_id"
		has_many :states, :dependent => :destroy

		#has_many :work_hours
		belongs_to :work_schedule

		belongs_to :group
		has_and_belongs_to_many :alarms
		has_many :alarm_cars, :dependent => :destroy

	accepts_nested_attributes_for :alarms

	# Cars for devices 

		def self.cars_without_devices(car_id)
			if car_id.nil?
				Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL AND deleted_at IS NULL)")
			else
				Car.where("id NOT IN (SELECT car_id FROM devices WHERE car_id IS NOT NULL AND car_id != #{car_id}) AND deleted_at IS NULL")
			end
		end

		def self.cars_without_drivers(car_id)
			if car_id.nil?
				Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL)")
			else
				Car.where("id NOT IN (SELECT car_id FROM users WHERE car_id IS NOT NULL AND car_id != #{car_id})")
			end
		end

		def time
			self.positions.last.time
		end

		def address
			self.positions.last.address
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

		def self.one_car_position(car)	
			position = Array.new
	        position << car.last_position
	    	return position
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
				has_no_device = !self.has_device?
				has_no_data = self.device.no_data?
				return has_no_device || has_no_data
			end

			def speed
				self.device.speed
			end

		# Alarms trigger

			def check_alarms
				# don't waste time checking if vehicle doesn't have device 
				return if !self.has_device? 
				
				results = {}

				self.alarms.all.each do |alarm|
					trigger = alarm.verify(self.id)

					if trigger == true
						if ActsAsTenant.current_tenant.nil?
							ActsAsTenant.current_tenant = self.company
						end

						# create alarm notification (so the same alarm doesn't get triggered too much times)
						AlarmNotification.create(alarm_id: alarm.id, car_id: self.id)

						results["#{alarm.name}"] = {status: true, car_id: self.id }
						Rails.logger.debug "Alarm : #{alarm.name} | Status : true"

						# Send email notification to managers
							subject =  "Alarm : #{alarm.name}"
							body = alarm.name
							#self.company.users.first.notify(subject, body, self)
							#send email to user with name of the alarm triggered
							#AlarmMailer.alarm_email(self.company.users.first, self, alarm).deliver
					else
						results["#{alarm.name}"] = {status: false, car_id: self.id }
						Rails.logger.debug "Alarm : #{alarm.name} | Status : false"
					end
				end

				return results

				# capture the current car state
				# self.capture_state
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


	# dates = {start_date, start_time, end_date, end_time}
	def positions_with_dates(dates, timezone)
		if dates.nil?
			self.device.traccar_device.positions.order("time DESC").limit(100)
		else
			Time.use_zone("#{timezone}") do

				start_date = Time.zone.parse("#{dates[:start_date]} #{dates[:start_time]}").utc

				end_date = Time.zone.parse("#{dates[:end_date]} #{dates[:end_time]}").utc

				# dates[:limit_results] = 20 if dates[:limit_results].to_i == 0

				# positions = self.device.traccar_device.positions.where("time >= ? AND time <= ?", start_date.to_s(:db), end_date.to_s(:db)).order("time ASC")
				positions = Location.where("time >= ? AND time <= ?", start_date.to_s(:db), end_date.to_s(:db)).order("time ASC")
				
				Rails.logger.warn "positions #{positions.count}"
				return positions
			end
		end
	end

	def positions_for_date(day)
		date = Chronic.parse(day.to_s)
		self.positions.where("time > ? AND time < ?", date, date + 1.day)
	end

	def distance
	end

end
