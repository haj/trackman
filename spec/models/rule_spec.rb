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

require 'spec_helper'

describe Rule do

	before(:all) do
		Time.zone = "GMT"
		# Create Car, Device, Traccar::Device
		@car = Car.create!(numberplate: "44444")		
		@device = Device.create!(name: "Device", emei: "44444", car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")
  	end

  	describe "Alarm when vehicle not sending data for more than X minutes" do 
  		it "should trigger alarm when no data received" do 

  		end
	end

  	describe "Alarm when vehicle stopped for more than X minutes" do 

  		before(:all) do 
  			rule = Rule.where(method_name: "stopped_for_more_than").first
			alarm = Alarm.create!(name: "Vehicle stopped for more than few 15 minutes in the last 12 hours")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'threshold' => '15', 'scope'=>'720' }")
			@car.alarms << alarm
			State.destroy_all
  		end

  		it "should trigger alarm " do
  			# create states to simulate car stopped 
  			State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 60.minutes.ago)
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 45.minutes.ago)
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
	  		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
			Rule.first.stopped_for_more_than(@car.id, { 'threshold' => '15', 'scope'=>'120' }).should equal(true)
  		end

  		it "shouldn't trigger alarm " do
  			# create states to simulate car stopped 
  			State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 50.minutes.ago)
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 45.minutes.ago)
	  		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
	  		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
			Rule.first.stopped_for_more_than(@car.id, { 'threshold' => '15', 'scope'=>'120' }).should equal(false)
  		end

	end

	describe "Vehicle driving for long hours", focus: true do 

  		before(:all) do 
  			rule = Rule.where(method_name: "driving_consecutive_hours").first
			alarm = Alarm.create!(name: "Vehicle driving for more than 15 minutes in the last 2 hours")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'threshold' => '15', 'scope'=>'120' }")
			@car.alarms << alarm
			State.destroy_all
  		end

  		it "should trigger alarm " do
  			# create states to simulate car stopped 
  			State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 60.minutes.ago)
	  		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 45.minutes.ago)
	  		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
	  		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
			Rule.first.driving_consecutive_hours(@car.id, { 'threshold' => '15', 'scope'=>'120' }).should equal(true)
  		end

  		it "shouldn't trigger alarm " do
  			# create states to simulate car stopped 
  			State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 50.minutes.ago)
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 45.minutes.ago)
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
			Rule.first.driving_consecutive_hours(@car.id, { 'threshold' => '15', 'scope'=>'120' }).should equal(false)
  		end

	end

	describe "Alarm when vehicle started moving" do 
		before(:each) do
			rule = Rule.where(method_name: "starts_moving").first
			alarm = Alarm.create!(name: "Vehicle starts moving")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "")
			@car.alarms << alarm
  		end

		it "should take off when vehicle starts moving" do 
	  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 3.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			Rule.first.starts_moving(@car.id, { }).should equal(true)
		end

		it "shouldn't take off if car didn't move" do 
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			Rule.first.starts_moving(@car.id, { }).should equal(false)
		end
	end

	describe "Alarm when vehicle moving with engine off" do 
		it "shouldn't trigger alarm when no data received from vehicle" do

		end

		it "shouldn't trigger alarm when vehicle not moving" do 

		end

		it "should trigger alarm when " do

		end
	end

	describe "Alarm when vehicle going > X km/h" do 

		before(:each) do
      		# setup rules
			# setup alarm with params
    	end

		it "shouldn't trigger alarm when no data received from vehicle" do
			Traccar::Position.destroy_all
			rule = Rule.where(method_name: "speed_limit").first
			alarm = Alarm.create!(name: "Vehicle is going faster than 60 km/h")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'speed'=> '60.0'}")
			@car.alarms << alarm
			Rule.first.speed_limit(@car.id, { "speed" => 60 }).should equal(false)
		end

		pending "shouldn't trigger alarm when vehicle not moving" do 

		end

		it "shouldn't trigger alarm if speed < 60 km/h" do 
			rule = Rule.where(method_name: "speed_limit").first
			alarm = Alarm.create!(name: "Vehicle is going faster than 60 km/h")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'speed'=> '60.0'}")
			@car.alarms << alarm	
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 50.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			Rule.first.speed_limit(@car.id, { "speed" => 60 }).should equal(false)
		end

		it "should trigger alarm when speed > X km/h" do 
			rule = Rule.where(method_name: "speed_limit").first
			alarm = Alarm.create!(name: "Vehicle is going faster than 60 km/h")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'speed'=> '60.0'}")
			@car.alarms << alarm	
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 70.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			Rule.first.speed_limit(@car.id, { "speed" => 60 }).should equal(true)
		end
	end

	describe "Alarm when vehicle used outside work hours" do 
		before(:all) do
			
			@work_schedule = WorkSchedule.create(name: "some_random_work_schedule")
			start_time = Time.zone.parse("8 am").to_s(:db)
			end_time = Time.zone.parse("6 pm").to_s(:db)
			for i in 1..5
				WorkHour.create(day_of_week: i, starts_at: start_time , ends_at:  end_time , work_schedule_id: @work_schedule.id)
			end
			@car.update_attribute(:work_schedule_id, @work_schedule.id)
			rule = Rule.where(method_name: "movement_not_authorized").first
			alarm = Alarm.create!(name: "Car moving outside work hours")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "")
			@car.alarms << alarm
		end

		before(:each) do 
			Traccar::Position.destroy_all
		end

		it "should trigger off alarm when vehicle used outside work hours" do
			trigger_time = Time.zone.parse(Chronic.parse('sunday 8:00').to_s)
	  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 60.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 49.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 120.0, time: trigger_time + 2.minutes, created_at: trigger_time + 2.minutes, valid: true, device_id: @traccar_device.id)
			Rule.first.movement_not_authorized(@car.id, { }).should equal(true)
		end

		it "shouldn't trigger off alarm when vehicle used during work hours" do
			trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
	  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
			Rule.first.movement_not_authorized(@car.id, { }).should equal(false)
		end

		it "shouldn't trigger off alarm when vehicle not sending data" do
			trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
	  		#@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
			Rule.first.movement_not_authorized(@car.id, { }).should equal(false)
		end

		it "shouldn't trigger off alarm when vehicle not moving" do
			trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
	  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
			Rule.first.movement_not_authorized(@car.id, { }).should equal(false)
		end


	end	

	describe "Alarm when vehicle got in/out of an area" do

		before(:each) do
			Traccar::Position.destroy_all
			@region = Region.create!(name: "Statue of Liberty")
			Vertex.create!([
				{latitude: 40.69121432764299, longitude: -74.0477442741394, region_id: @region.id},
				{latitude: 40.68931071707278, longitude: -74.04714345932007, region_id: @region.id},
				{latitude: 40.688480921087525, longitude: -74.04557704925537, region_id: @region.id},
				{latitude: 40.68838329735111, longitude: -74.04416084289551, region_id: @region.id},
				{latitude: 40.68896903762434, longitude: -74.04300212860107, region_id: @region.id},
				{latitude: 40.690368285214454, longitude: -74.04360294342041, region_id: @region.id},
				{latitude: 40.69121432764299, longitude: -74.04600620269775, region_id: @region.id}
			])
			@liberty_statue = { :latitude => 40.689249, :longitude => -74.0445 }
  		end


		it "should trigger alarm when car leaves an area" do 
			rule = Rule.where(method_name: "leave_area").first
			alarm = Alarm.create!(name: "Car Left the Statue of liberty area")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'region_id'=>'#{@region.id}'}")
			@car.alarms << alarm	
	  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: @liberty_statue[:latitude], longitude: @liberty_statue[:longitude], other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			Rule.first.leave_area(@car.id, { "region_id" => @region.id }).should equal(true)
		end 

		it "should trigger alarm when car enters an area" do 
			rule = Rule.where(method_name: "enter_area").first			
			alarm = Alarm.create!(name: "Car Entered Statue of liberty area")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'region_id'=>'#{@region.id}'}")
			@car.alarms << alarm
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
	  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: @liberty_statue[:latitude], longitude: @liberty_statue[:longitude], other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			Rule.first.enter_area(@car.id, { "region_id" => @region.id }).should equal(true)
		end

	end	

	describe "Alarm when vehicle got out of the planned route" do 
	end	

end
