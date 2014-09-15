require 'spec_helper'

describe "Outside Work Hours Alarm" do 

	before(:each) do
		Time.zone = "GMT"
		@car = Car.create!(numberplate: "44444")		
		@device = Device.create!(name: "Device", emei: "44444", car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")

		@work_schedule = WorkSchedule.create(name: "some_random_work_schedule")
		start_time = Time.zone.parse("8 am").to_s(:db)
		end_time = Time.zone.parse("6 pm").to_s(:db)
		for i in 1..5
			WorkHour.create(day_of_week: i, starts_at: start_time , ends_at:  end_time , work_schedule_id: @work_schedule.id)
		end
		@car.update_attribute(:work_schedule_id, @work_schedule.id)
		@rule = Rule.where(method_name: "movement_not_authorized").first
		alarm = Alarm.create!(name: "Car moving outside work hours")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "")
		@car.alarms << alarm

		Traccar::Position.destroy_all
  	end

  	it "should trigger off alarm when vehicle used outside work hours" do
		trigger_time = Time.zone.parse(Chronic.parse('sunday 8:00').to_s)
  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 60.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
		@rule.movement_not_authorized(@car.id, { }).should equal(true)

		Timecop.freeze(trigger_time + 16.minutes) do
			@rule.starts_moving(@car.id, nil).should equal(false)
		end
	end

	it "shouldn't trigger off alarm when vehicle used during work hours" do
		trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
		@rule.movement_not_authorized(@car.id, { }).should equal(false)

		Timecop.freeze(trigger_time + 16.minutes) do
			@rule.starts_moving(@car.id, nil).should equal(false)
		end
	end

	it "shouldn't trigger off alarm when vehicle not sending data" do
		trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
		@rule.movement_not_authorized(@car.id, { }).should equal(false)

		Timecop.freeze(trigger_time + 16.minutes) do
			@rule.starts_moving(@car.id, nil).should equal(false)
		end
	end

	it "shouldn't trigger off alarm when vehicle not moving" do
		trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: trigger_time, created_at: trigger_time, valid: true, device_id: @traccar_device.id)
		@rule.movement_not_authorized(@car.id, { }).should equal(false)
	end

end

