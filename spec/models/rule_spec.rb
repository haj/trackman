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

describe Rule do

  	describe "alarm when vehicle not sending data for more than X minutes" do 
  		it "should trigger alarm when no data received" do 

  		end
	end

  	describe "alarm when vehicle stopped for more than X minutes" do 

	end

	describe "alarm when vehicle moving for more than X minutes" do 

	end

	describe "alarm when vehicle started moving" do 
	end

	describe "alarm when vehicle moving with engine off" do 
		it "shouldn't trigger alarm when no data received from vehicle" do

		end

		it "shouldn't trigger alarm when vehicle not moving" do 

		end

		it "should trigger alarm when " do

		end
	end

	describe "alarm when vehicle going faster than X km/h" do 

		before(:each) do
      		# setup rules
			# setup alarm with params
    	end

		it "shouldn't trigger alarm when no data received from vehicle" do
		end

		it "shouldn't trigger alarm when vehicle not moving" do 

		end

		it "should trigger alarm when speed > X km/h" do 
			# setup few positions where car is moving + speed > X 
			

		end
	end

	describe "alarm when vehicle going slower than X km/h" do 
		it "shouldn't trigger alarm when no data received from vehicle" do
		end

		it "shouldn't trigger alarm when vehicle not moving" do 
		end

		it "should trigger alarm when speed < X km/h" do 
		end
	end

	describe "alarm when vehicle used outside work hours" do 
		it "should return when vehicle used outside work hours" do 
			
		end
	end	

	describe "alarm when vehicle got out of an area" do

		it "should trigger alarm when car leaves an area" do 

			Rule.destroy_all
			Car.destroy_all
			Device.destroy_all
			Region.destroy_all
			Vertex.destroy_all
			Alarm.destroy_all
			AlarmRule.destroy_all
			Traccar::Position.destroy_all
			Traccar::Device.destroy_all

			# create rule + parameter for leaving area
			rule = Rule.create!(name: "Left area", method_name: "left_an_area")
			Parameter.create!(name: "region_id", data_type: "integer", rule_id: rule.id)

			# Create Car, Device, Traccar::Device
			car = Car.create!(numberplate: "44444")
			
			device = Device.create!(name: "Device", emei: "44444", car_id: car.id)
			traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")

			# Create region with vertices 
			region = Region.create!(name: "Statue of Liberty")
			Vertex.create!([
				{latitude: 40.69121432764299, longitude: -74.0477442741394, region_id: region.id},
				{latitude: 40.68931071707278, longitude: -74.04714345932007, region_id: region.id},
				{latitude: 40.688480921087525, longitude: -74.04557704925537, region_id: region.id},
				{latitude: 40.68838329735111, longitude: -74.04416084289551, region_id: region.id},
				{latitude: 40.68896903762434, longitude: -74.04300212860107, region_id: region.id},
				{latitude: 40.690368285214454, longitude: -74.04360294342041, region_id: region.id},
				{latitude: 40.69121432764299, longitude: -74.04600620269775, region_id: region.id}
			])

			# create new alarm
			alarm = Alarm.create!(name: "Car Left the Statue of liberty area")
			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'region_id'=>'#{region.id}'}")
			car.alarms << alarm

			# simulate being inside that area
			liberty_statue = { :latitude => 40.689249, :longitude => -74.0445 }
	  		inside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: liberty_statue[:latitude], longitude: liberty_statue[:longitude], other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: traccar_device.id)
	  		traccar_device.positions << inside_position
	  		traccar_device.save!
	  		# simulate being outside
			outside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: traccar_device.id)
	  		traccar_device.positions << outside_position
	  		traccar_device.save!

			# check if alarm triggered
			Rule.first.left_an_area(car.id, { "region_id" => region.id }).should equal(true)

			Traccar::Device.destroy_all
		end 

	end	

	describe "alarm when vehicle got into  an area" do 

		it "should trigger alarm when car enters an area" do 

			# create car
			car = Car.create!(mileage: 134.0, numberplate: "35133555", car_model_id: 1, car_type_id: 1, registration_no: "13513553", year: 2011, color: "Red", group_id: 1, company_id: 2, work_schedule_id: 5)
			device = Device.create!(name: "Device", emei: "44444", car_id: car.id, company_id: 2, movement: true, last_checked: "2014-06-18 16:15:45")
			traccar_device = Traccar::Device.create(name: "Device", uniqueId: "44444")

			# create region with vertices 
			region = Region.create!(name: "Statue of Liberty")

			Vertex.create!([
				{latitude: 40.69121432764299, longitude: -74.0477442741394, region_id: region.id},
				{latitude: 40.68931071707278, longitude: -74.04714345932007, region_id: region.id},
				{latitude: 40.688480921087525, longitude: -74.04557704925537, region_id: region.id},
				{latitude: 40.68838329735111, longitude: -74.04416084289551, region_id: region.id},
				{latitude: 40.68896903762434, longitude: -74.04300212860107, region_id: region.id},
				{latitude: 40.690368285214454, longitude: -74.04360294342041, region_id: region.id},
				{latitude: 40.69121432764299, longitude: -74.04600620269775, region_id: region.id}
			])

			# create rule for entering area
			rule = Rule.create!(name: "Entered area", method_name: "entered_an_area")

			Parameter.create!(name: "region_id", data_type: "integer", rule_id: rule.id)

			# create new alarm
			alarm = Alarm.create!(name: "Car Entered Statue of liberty area")

			AlarmRule.create!(rule_id: rule.id, alarm_id: alarm.id, conjunction: nil, params: "{'region_id'=>'#{region.id}'}")

			# attach alarm to car
			car.alarms << alarm

			# simulate entering area
			outside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: 48.856614, longitude: 2.352222, other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: traccar_device.id)
	  		traccar_device.positions << outside_position

	  		liberty_statue = { :latitude => 40.689249, :longitude => -74.0445 }

	  		inside_position = Traccar::Position.create(altitude: 0.0, course: 0.0, latitude: liberty_statue[:latitude], longitude: liberty_statue[:longitude], other: "<info><protocol>t55</protocol><battery>24</battery...", power: nil, speed: 0.0, time: Time.now, valid: true, device_id: traccar_device.id)
	  		traccar_device.positions << inside_position

			# check if alarm triggered
			Rule.first.entered_an_area(car.id, { "region_id" => region.id }).should equal(true)

			Traccar::Device.destroy_all
		end

	end	

	describe "alarm when vehicle got out of the planned route" do 
	end	





end
