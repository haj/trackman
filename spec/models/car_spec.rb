	# == Schema Information
	#
	# Table name: cars
	#
	#  id              :integer          not null, primary key
	#  mileage         :float
	#  numberplate     :string(255)
	#  car_model_id    :integer
	#  car_type_id     :integer
	#  registration_no :string(255)
	#  year            :integer
	#  color           :string(255)
	#  group_id        :integer
	#  created_at      :datetime
	#  updated_at      :datetime
	#  company_id      :integer
	#

require 'spec_helper'

describe Car do

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

	end
	
end
