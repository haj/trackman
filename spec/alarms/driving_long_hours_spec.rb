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

describe "Driving long hours" do

	before(:all) do
		Time.zone = "GMT"
		@car = FactoryGirl.create(:car, numberplate: "44444")		
		@device = FactoryGirl.create(:device, name: "Device", emei: "44444", car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")
		@rule = Rule.where(method_name: "driving_consecutive_hours").first
		alarm = Alarm.create!(name: "Vehicle driving for more than 15 minutes in the last 2 hours")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'threshold' => '15', 'scope'=>'120' }")
		@car.alarms << alarm
  	end

  	it "should trigger alarm when car been driving for too long" do

		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 23.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 7.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
		@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(true)
		
		Timecop.freeze(Time.zone.now + 2.minutes) do
			@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(false)
		end

		Timecop.freeze(Time.zone.now + 15.minutes) do
			@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(false)
		end
	
	end

	it "shouldn't trigger alarm if car didn't send any data" do
		State.create(no_data: true)
		State.create(no_data: true)
		@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm when there is too little data" do
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
		@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm when there is too little data" do
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
		@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm if car didn't move at all" do
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
		@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(false)
	end


end
