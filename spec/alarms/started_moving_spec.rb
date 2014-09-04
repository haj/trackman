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

describe "Started Moving Alarm" do

	before(:all) do
		Time.zone = "GMT"
		@car = Car.create!(numberplate: "44444")		
		@device = Device.create!(name: "Device", emei: "44444", car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")
		@rule = Rule.where(method_name: "starts_moving").first
		alarm = Alarm.create!(name: "Vehicle starts moving")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "")
		@car.alarms << alarm
		
  	end

  	before(:each) do
  		Traccar::Position.destroy_all
  	end

	it "should take off when vehicle starts moving" do 
  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 50.856614, longitude: 5.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		@rule.starts_moving(@car.id, nil).should equal(true)

		Timecop.freeze(Time.zone.now + 1.minutes) do
			@rule.starts_moving(@car.id, nil).should equal(false)
		end

		
		Timecop.freeze(Time.zone.now + 12.minutes) do
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now + 10.minutes, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 50.856614, longitude: 5.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now + 11.minutes, valid: true, device_id: @traccar_device.id)
			@rule.starts_moving(@car.id, nil).should equal(true)
		end

		# simulate the car stopped for a while
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: Time.zone.now + 20.minutes)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: Time.zone.now + 25.minutes)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: Time.zone.now + 30.minutes)

		Timecop.freeze(Time.zone.now + 31.minutes) do
			puts Alarm::Movement.vehicle_stopped(@car)
			@rule.starts_moving(@car.id, nil).should equal(true)
		end

		Timecop.freeze(Time.zone.now + 2.hours) do
			@rule.starts_moving(@car.id, nil).should equal(false)
		end

	end

	it "shouldn't take off if car didn't move" do 
		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		@rule.starts_moving(@car.id, nil).should equal(false)
	end


end
