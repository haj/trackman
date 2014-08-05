require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "device management" do

    before (:each) do
      device_manufacturer = FactoryGirl.create(:device_manufacturer)
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      user
    end

  it "should allow to create new device manufacturer" do     
    visit new_device_manufacturer_path
    page.should have_css('#device_manufacturer_name')

    fill_in "device_manufacturer_name", :with => "NewDeviceManufacturer"
    click_button "Save"

    DeviceManufacturer.where(name: "NewDeviceManufacturer").should exist
    page.should have_content("Device manufacturer was successfully created")
  end

  pending "should allow to destroy a device manufacturer" do 
    visit device_manufacturers_path
    expect { click_link 'Destroy' }.to change(DeviceManufacturer, :count).by(-1)
  end

  it "should allow to list all device manufacturers" do 
    visit device_manufacturers_path
    page.should have_content('NewDeviceManufacturer')
  end

  it "should allow to edit a device manufacturer" do 

    visit edit_device_manufacturer_path(DeviceManufacturer.first)
    page.should have_css('#device_manufacturer_name')

    fill_in "device_manufacturer_name", :with => "NewDeviceManufacturer2"
    click_button "Save"

    DeviceManufacturer.where(name: "NewDeviceManufacturer").should_not exist
    DeviceManufacturer.where(name: "NewDeviceManufacturer2").should exist
  end

end