require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Speed limit" do

	before(:each) do
		Time.zone = "GMT"
		@car = FactoryGirl.create(:car, numberplate: "123")	
		@device = FactoryGirl.create(:device, name: "Device", emei: @car.numberplate, car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: @device.name, uniqueId: @device.emei)
		@rule = Rule.where(method_name: "speed_limit").first
		alarm = FactoryGirl.create(:alarm, name: "Vehicle is going faster than 60 km/h")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'speed'=> '60.0'}")
		@car.alarms << alarm
		Traccar::Position.destroy_all
  	end

  	after(:all) do
  		Device.destroy_all
  		Traccar::Position.destroy_all
  	end

  	it "Should trigger alarm when speed > X km/h" do 	
		@traccar_device.positions << FactoryGirl.create(:position, speed: 70.0, device_id: @traccar_device.id)
		@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(true)
		@traccar_device.positions << FactoryGirl.create(:position, speed: 50.0, device_id: @traccar_device.id)
		@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(false)
	end	

	it "Shouldn't trigger alarm when no data received from vehicle" do
		Traccar::Position.destroy_all
		@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(false)
	end

	it "Shouldn't trigger alarm when vehicle not moving" do
		State.destroy_all
		@traccar_device.positions << FactoryGirl.create(:position, speed: 50.0, device_id: @traccar_device.id)
		@traccar_device.positions << FactoryGirl.create(:position, speed: 50.0, device_id: @traccar_device.id)
 		@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(false)
	end

	it "Shouldn't trigger alarm if speed < 60 km/h" do 
		@traccar_device.positions << FactoryGirl.create(:position, speed: 50.0, device_id: @traccar_device.id)
		@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(false)
	end

	it "Shouldn't trigger alarm two times if repeat notification time didn't elapse yet " do 
		@traccar_device.positions << FactoryGirl.create(:position, speed: 70.0, device_id: @traccar_device.id)
		@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(true)
		
		Timecop.freeze(Time.zone.now + 9.minutes) do
			@traccar_device.positions << FactoryGirl.create(:position, speed: 70.0, device_id: @traccar_device.id)
			@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(false)
		end 
	end

	it "Should trigger alarm if repeat notification elapsed" do
		@traccar_device.positions << FactoryGirl.create(:position, speed: 70.0, device_id: @traccar_device.id)
		@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(true)

		Timecop.freeze(Time.zone.now + 11.minutes) do
			@traccar_device.positions << FactoryGirl.create(:position, speed: 70.0, device_id: @traccar_device.id)
			@rule.speed_limit(@car.id, { "speed" => 60, "repeat_notification" => "10" }).should equal(true)
		end 
	end



	

end
