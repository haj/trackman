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

	def cleanup
  		Traccar::Device.destroy_all
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

  	describe "long drive alarm" do 

		it "Should trigger alarm (one time only) when driver been using vehicle for too long (> threshold in minutes)", focus: true do
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 23.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 7.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(true) 
			
			Timecop.freeze(Time.zone.now + 2.minutes) do
				result = @rule.driving_consecutive_hours(@car.id, { threshold: '15' })
				expect(result).to equal(false)
			end

			Timecop.freeze(Time.zone.now + 15.minutes) do
				result = @rule.driving_consecutive_hours(@car.id, { threshold: '15' })
				expect(result).to equal(false)
			end

		end

		it "Shouldn't trigger alarm if car didn't send any data" do
			FactoryGirl.create(:state, no_data: true)
			FactoryGirl.create(:state, no_data: true)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(false)
		end

		it "Shouldn't trigger alarm when there isn't much data" do
			FactoryGirl.create(:state, no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(false)
		end

		it "Shouldn't trigger alarm if car didn't move at all" do
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(false) 
		end

	end

	describe "started moving alarm" do 

		it "should be triggered when vehicle stopped then starts moving" do 
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

		it "shouldn't get triggered if car didn't move at all" do 
			Traccar::Position.destroy_all
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			@traccar_device.positions << Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.zone.now, valid: true, device_id: @traccar_device.id)
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(false)
		end

	end 

	describe "long pause" do 
		it "Should trigger alarm (one time only) when driver been using vehicle for too long (> threshold in minutes)", focus: true do
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 23.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 7.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(true) 
			
			Timecop.freeze(Time.zone.now + 2.minutes) do
				result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
				expect(result).to equal(false)
			end

			Timecop.freeze(Time.zone.now + 15.minutes) do
				result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
				expect(result).to equal(false)
			end

		end

		it "Shouldn't trigger alarm if car didn't send any data" do
			FactoryGirl.create(:state, no_data: true)
			FactoryGirl.create(:state, no_data: true)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(false)
		end

		it "Shouldn't trigger alarm when there isn't much data" do
			FactoryGirl.create(:state, no_data: false, moving: true, car_id: @car.id, speed: 0.0, created_at: 2.minutes.ago)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(false)
		end

		it "Shouldn't trigger alarm if car didn't move at all" do
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 30.minutes.ago)
			FactoryGirl.create(:state, no_data: false, moving: false, car_id: @car.id, speed: 0.0, created_at: 15.minutes.ago)
			result = @rule.driving_consecutive_hours(@car.id, { 'threshold' => '15' })
			expect(result).to equal(false) 
		end

		it "check alarms" do 
			puts @car.check_alarms
			@car.capture_state
		end

	end


end
