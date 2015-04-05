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

require "spec_helper"

describe "Multiple alarms" do


	skip "should trigger correct alarms" do 
		@traccar_device.positions << Traccar::Position.create(latitude: 48.856614, longitude: 2.352222, speed: 0.0, time: Time.zone.now + 10.minutes, valid: true, device_id: @traccar_device.id)
		@traccar_device.positions << Traccar::Position.create(latitude: 50.856614, longitude: 5.352222, speed: 0.0, time: Time.zone.now + 11.minutes, valid: true, device_id: @traccar_device.id)
		@car.check_alarms
		
		Timecop.freeze(Time.zone.now + 12.minutes) do
		end

		puts 
		@car.capture_state
  	end

	def cleanup
  		Traccar::Device.destroy_all
  		Traccar::Position.destroy_all
  	end

	before(:all) do
		Time.zone = "GMT"
		cleanup
		@car = FactoryGirl.create(:car, numberplate: "44444")		
		@device = FactoryGirl.create(:device, name: "Device", emei: @car.numberplate, car_id: @car.id)
		@traccar_device = Traccar::Device.create(name: @device.name, uniqueId: @device.emei)

		# long drive alarm 
		@rule = Rule.where(method_name: "driving_consecutive_hours").first
		alarm = FactoryGirl.create(:alarm, name: "Vehicle driving for more than 15 minutes in the last 2 hours")
		AlarmRule.create(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: {threshold: '15', scope: '120'} )
		@car.alarms << alarm

		# started moving alarm
		@rule = Rule.where(method_name: "starts_moving").first
		alarm = Alarm.create!(name: "Vehicle starts moving")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "")
		@car.alarms << alarm

		# long pause alarm
		@rule = Rule.where(method_name: "stopped_for_more_than").first
		alarm = FactoryGirl.create(:alarm, name: "Vehicle stopped for more than 15 minutes in the last 2 hours")
		AlarmRule.create(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'threshold' => '15' }")
		@car.alarms << alarm
  	end

  	after(:all) do
  		Device.destroy_all
  	end
end
