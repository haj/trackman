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
      return self.send(self.method_name, car_id, params)
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

      @car = Car.find car_id

      duration = params["threshold"].to_i

      # this represent to which point in time we'll go back to look if car stopped for more than X minutes
      # scope = threshold*2

      rule_alerts = RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, duration.minutes.ago)

      # if a previous alarm of this type was triggered, then cancel this one
      if rule_alerts.count != 0
        return false
      end
          
      since_last_seen = (@car.last_seen - DateTime.now).abs
      since_last_seen_in_minutes = (since_last_seen / 1.minute).round

      if since_last_seen_in_minutes >= duration
        RuleNotification.create(rule_id: self.id, car_id: car_id)
        return true
      end

      return false
    end

    # Vehicle driving for more than consecutive params["threshold"] (duration) minutes
    def driving_consecutive_hours(car_id, params)

      threshold = params["threshold"].to_i

      # This is how much in time we'll go to back when looking if car stopped or not.
      # basically if user is looking if car stopped for more than 15 minutes, scope would be 30 minuts, 
      # which means we'll check if the car stopped for more than 15 minutes in the last 30 minutes just to be sure! 
      scope = threshold*2

      rule_alerts = RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, threshold.minutes.ago)

      # We check if this particular alarm was triggered before, if so then no need to re-trigger it, which means no need to check
      if rule_alerts.count != 0
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

    # Vehicle moving faster than a particular speed (params["speed"])
    # How it works : 
    # Fetch all positions after x minutes ago, and look for the ones where speed was > then a particular speed 
    def speed_limit(car_id, params)

      repeat_notification = params['repeat_notification'].to_i
      speed = params["speed"].to_i

      car = Car.find(car_id)
      
      rule_alerts = RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id,  10.minutes.ago)
      
      if rule_alerts.count != 0 || car.no_data?
        return false
      end

      speed_positions = car.device.traccar_device.positions.where("time > ? AND speed > ?", repeat_notification.minutes.ago, speed)

      if speed_positions.count > 0
        RuleNotification.create(rule_id: self.id, car_id: car_id)
        return true
      else
        return false
      end
    end

    # Vehicle moving during (or not) work hours
    def movement_not_authorized(car_id, params)

      repeat_notification = params["repeat_notification"].to_i

      # setup the car we can apply this rule to
      car = Car.find(car_id)

      # else we can proceed to check if car moving outside work hours
      last_position = car.positions.where("time > ?", 5.minutes.ago).last

      rule_alerts = RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, repeat_notification.minutes.ago)

      # if we raised an alarm like this in the last 30 minutes, then we don't have to raise another one again, so no need to even check if it's true
      if rule_alerts.count != 0 || last_position.nil? || car.work_schedule.nil?
        return false
      else 
        current_time = last_position.time.to_time_of_day
        current_day_of_week = last_position.time.wday
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
      scope = 5 #5 minutes ago

      if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, scope.minutes.ago).count != 0 || current_position.nil?
        return false
      end

      region = Region.find(params["region_id"].to_i)
      
      positions = car.device.traccar_device.positions.where("time > ?", scope.minutes.ago).order("time DESC")
      inside_position = nil

      positions.each do |position|
        if region.contains_point(position.latitude, position.longitude)
          inside_position = position
          break
        end
      end

      if inside_position.nil?
        return false
      else
        positions = car.device.traccar_device.positions.where("time > ? AND time < ?", scope.minutes.ago, inside_position.time)
        positions.each do |position|
          if !region.contains_point(position.latitude, position.longitude)
            RuleNotification.create(rule_id: self.id, car_id: car_id)
            return true
          end
        end
        return false 
      end
    end

    # This will check if vehicle left a particular area
    # Basically this will check first if the vehicle was inside the area, and if it's currently outside the selected area
    def leave_area(car_id, params)

      car = Car.find(car_id)
      current_position, previous_position = car.device.last_positions

      scope = 5 # 5 minutes ago

      if RuleNotification.where("rule_id = ? AND car_id = ? AND created_at >= ?", self.id, car_id, scope.minutes.ago).count != 0 || current_position.nil?
        return false
      end
      
      region = Region.find(params["region_id"].to_i)

      positions = car.device.traccar_device.positions.where("time > ?", scope.minutes.ago).order("time DESC")
      outside_position = nil

      positions.each do |position|
        if !region.contains_point(position.latitude, position.longitude)
          outside_position = position
          break
        end
      end

      if outside_position.nil?
        return false
      else
        positions = car.device.traccar_device.positions.where("time > ? AND time < ?", scope.minutes.ago, outside_position.time)
        positions.each do |position|
          if region.contains_point(position.latitude, position.longitude)
            RuleNotification.create(rule_id: self.id, car_id: car_id)
            return true
          end
        end
        return false 
      end
    end

    # TODO : Vehicle moving outside planned route
    def left_planned_route(car_id, params)

    end

end
