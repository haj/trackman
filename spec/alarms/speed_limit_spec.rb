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

describe "Speed limit" do

	before(:all) do
		Time.zone = "GMT"
		@car = Car.create!(numberplate: "44444")		
		@device = Device.create!(name: "Device", emei: "44444", car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")
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

	

end
