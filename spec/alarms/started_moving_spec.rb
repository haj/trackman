require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Started Moving Alarm" do

	before(:all) do
		Time.zone = "GMT"
		@car = FactoryGirl.create(:car, numberplate: "123")		
		@device = FactoryGirl.create(:device, name: "Device", emei: @car.numberplate, car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: @device.name, uniqueId: @device.emei)
		@rule = Rule.where(method_name: "starts_moving").first
		alarm = Alarm.create!(name: "Vehicle starts moving")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "")
		@car.alarms << alarm
  	end

  	after(:all) do
  		Device.destroy_all
  	end

  	before(:each) do
  		Traccar::Position.destroy_all
  	end

	it "should be triggered when vehicle was stopped then starts moving" do 
  		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 70.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 50.856614, longitude: 5.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 70.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		result = @rule.starts_moving(@car.id, nil)
		expect(result).to equal(true)

		Timecop.freeze(Time.zone.now + 1.minutes) do
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(false)
		end

		
		Timecop.freeze(Time.zone.now + 12.minutes) do
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now + 10.minutes, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 50.856614, longitude: 5.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now + 11.minutes, valid: true, device_id: @traccar_device.id)
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(true)
		end

		# simulate the car stopped for a while
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: Time.zone.now + 20.minutes)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: Time.zone.now + 25.minutes)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: Time.zone.now + 30.minutes)

		Timecop.freeze(Time.zone.now + 31.minutes) do
			#puts Alarm::Movement.vehicle_stopped(@car)
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(true)
		end

		Timecop.freeze(Time.zone.now + 2.hours) do
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(false)
		end

	end

	it "Shouldn't take off if car didn't move" do 
		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
		result = @rule.starts_moving(@car.id, nil)
		expect(result).to equal(false)
	end


end
