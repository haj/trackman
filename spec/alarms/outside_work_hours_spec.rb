require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Outside Work Hours Alarm" do 

	before(:each) do
		Time.zone = "GMT"
		@car = FactoryGirl.create(:car, numberplate: "123")		
		@device = FactoryGirl.create(:device, name: "Device", emei: @car.numberplate, car_id: @car.id)
		Traccar::Device.destroy_all
		@traccar_device = Traccar::Device.create(name: "Device", uniqueId: @device.emei)
		@work_schedule = FactoryGirl.create(:work_schedule, name: "some_random_work_schedule")
		start_time = Time.zone.parse("8 am").to_s(:db)
		end_time = Time.zone.parse("6 pm").to_s(:db)
		for i in 1..5
			FactoryGirl.create(:work_hour, day_of_week: i, starts_at: start_time , ends_at:  end_time , work_schedule_id: @work_schedule.id)
		end
		@car.update_attribute(:work_schedule_id, @work_schedule.id)
		@rule = Rule.where(method_name: "movement_not_authorized").first
		alarm = FactoryGirl.create(:alarm, name: "Car moving outside work hours")
		AlarmRule.create!(rule_id: @rule.id, alarm_id: alarm.id, conjunction: nil, params: "")
		@car.alarms << alarm

		Traccar::Position.destroy_all
  	end

  	after(:all) do
  		Device.destroy_all
  	end

  	it "Should trigger off alarm when vehicle used outside work hours" do
		trigger_time = Time.zone.parse(Chronic.parse('sunday 8:00').to_s)

  		@traccar_device.positions << FactoryGirl.create(:position, 
  			speed: 60.0, 
  			time: trigger_time,
  			device_id: @traccar_device.id)

		result = @rule.movement_not_authorized(@car.id, { })
		expect(result).to equal(true)

		Timecop.freeze(trigger_time + 16.minutes) do
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(false)
		end
	end

	it "shouldn't trigger off alarm when vehicle used during work hours" do
		trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
		@traccar_device.positions << FactoryGirl.create(:position, 
  			speed: 60.0, 
  			time: trigger_time,
  			device_id: @traccar_device.id)		
		result = @rule.movement_not_authorized(@car.id, { })
		expect(result).to equal(false)

		Timecop.freeze(trigger_time + 16.minutes) do
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(false)
		end
	end

	it "shouldn't trigger off alarm when vehicle not sending data" do
		trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
		result = @rule.movement_not_authorized(@car.id, { })
		expect(result).to equal(false)

		Timecop.freeze(trigger_time + 16.minutes) do
			result = @rule.starts_moving(@car.id, nil)
			expect(result).to equal(false)
		end
	end

	it "shouldn't trigger off alarm when vehicle not moving" do
		trigger_time = Time.zone.parse(Chronic.parse('monday 9:00').to_s)
		@traccar_device.positions << FactoryGirl.create(:position, 
  			speed: 60.0, 
  			time: trigger_time,
  			device_id: @traccar_device.id)
		@traccar_device.positions << FactoryGirl.create(:position, 
  			speed: 60.0, 
  			time: trigger_time,
  			device_id: @traccar_device.id)
		result = @rule.movement_not_authorized(@car.id, { })
		expect(result).to equal(false)
	end

end

