# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  emei            :string(255)
#  cost_price      :float(24)
#  created_at      :datetime
#  updated_at      :datetime
#  device_model_id :integer
#  device_type_id  :integer
#  car_id          :integer
#  company_id      :integer
#  movement        :boolean
#  last_checked    :datetime
#  deleted_at      :datetime
#

require 'spec_helper'

describe Device do
 

	describe "callbacks", focus: true do 

		before(:each) do
			Device.destroy_all
			Traccar::Device.destroy_all
		end

		it "there shouldn't be more than traccar_device for each device" do 
			first_device = Traccar::Device.create(name: "emei", uniqueId: "emei")
			second_device = Traccar::Device.new(name: "emei", uniqueId: "emei")
			expect(second_device.save).to eq false
		end

		it "should create traccar_device when saved" do
			device = FactoryGirl.build(:device)
			traccar_devices = Traccar::Device.where(uniqueId: device.emei)
			expect(traccar_devices.count).to eq 0
			device.save
			expect(traccar_devices.count).to eq 1
			expect(traccar_devices.first.name).to eq device.name
			expect(traccar_devices.first.uniqueId).to eq device.emei
		end

		it "should update traccar_device when updated" do 
			# create device 
			device = FactoryGirl.create(:device)
			# make sure traccar_device has correct data 
			traccar_devices = Traccar::Device.where(uniqueId: device.emei)
			traccar_device = traccar_devices.first

			expect(traccar_devices.count).to eq 1
			expect(traccar_device.uniqueId).to eq device.emei

			# update device 
			device.update_attributes(emei: "123")
			# make sure traccar_device has new data
			expect(device.traccar_device.uniqueId).to eq "123"
			traccar_devices = Traccar::Device.where(uniqueId: device.emei)
			traccar_device = traccar_devices.first
			expect(traccar_device.uniqueId).to eq "123"
		end

		it "should destroy traccar_device when destroyed" do
			device = FactoryGirl.create(:device)
			traccar_devices = Traccar::Device.where(uniqueId: device.emei)
			expect(traccar_devices.count).to eq 1
			device.destroy
			traccar_devices = Traccar::Device.where(uniqueId: device.emei)
			expect(traccar_devices.count).to eq 0
		end

	end 


end
