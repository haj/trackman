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

describe "Stopped for too long alarm" do

	before(:all) do
		Time.zone = "GMT"
		@car = Car.create!(numberplate: "44444")		
		@device = Device.create!(name: "Device", emei: "44444", car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")
		@rule = Rule.where(method_name: "stopped_for_more_than").first
		alarm = Alarm.create!(name: "Vehicle stopped for more than few 15 minutes in the last 30 minutes")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "{ 'threshold' => '15' }")
		@car.alarms << alarm		
  	end

  	before(:each) do 
  		State.destroy_all
  	end

	it "should trigger alarm when car stops for too long" do
		# create states to simulate car stopped 
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 23.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 7.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(true)

		Timecop.freeze(Time.zone.now + 1.minutes) do
			@rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' }).should equal(false)
		end

		Timecop.freeze(Time.zone.now + 40.minutes) do
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 10.minutes.ago)
	  		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 5.minutes.ago)
	  		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
			@rule.stopped_for_more_than(@car.id, { 'threshold' => '5' }).should equal(true)
			@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(false)
		end
	end

	it "shouldn't trigger alarm when there is too little data" do
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm when there is too little data" do
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm when car didn't stop at all" do
		# create states to simulate car stopped 
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 50.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 45.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm when car stopped for less than 15 minutes" do
		# create states to simulate car stopped 
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 50.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 45.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm when car stopped for more 15 minutes but 2 hours ago" do
		# create states to simulate car stopped 
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 3.hours.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 2.hours.ago)
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(false)
	end

	it "shouldn't trigger alarm when there is no data in the 15 minutes (stop more than = 15 minutes)" do
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '15' }).should equal(false) 
	end

	it "shouldn't check for stops beyond double the duration in the past" do
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 14.minutes.ago)
		State.create(no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 7.minutes.ago)
		State.create(no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
		@rule.stopped_for_more_than(@car.id, { 'threshold' => '5' }).should equal(false) 
	end


end
