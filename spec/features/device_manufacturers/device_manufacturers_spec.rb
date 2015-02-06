require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe DeviceManufacturer do

  include_context "sign_in"
  include_context "sign_out"

  before (:each) do
    device_manufacturer = FactoryGirl.create(:device_manufacturer)
  end

  it "should allow to create new device manufacturer" do     
    visit new_device_manufacturer_path
    page.status_code.should be 200
    # page.should have_css('#device_manufacturer_name')

    # fill_in "device_manufacturer_name", :with => "NewDeviceManufacturer"
    # click_button "Save"

    # DeviceManufacturer.where(name: "NewDeviceManufacturer").should exist
    # page.should have_content("Device manufacturer was successfully created")
  end

  skip "should allow to destroy a device manufacturer" do 
    visit device_manufacturers_path
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(DeviceManufacturer, :count).by(-1)
  end

  it "should allow to list all device manufacturers" do 
    visit device_manufacturers_path
    # page.should have_content('NewDeviceManufacturer')
  end

  it "should allow to edit a device manufacturer" do 

    visit edit_device_manufacturer_path(DeviceManufacturer.first)
    page.status_code.should be 200
    # page.should have_css('#device_manufacturer_name')

    # fill_in "device_manufacturer_name", :with => "NewDeviceManufacturer2"
    # click_button "Save"

    # DeviceManufacturer.where(name: "NewDeviceManufacturer").should_not exist
    # DeviceManufacturer.where(name: "NewDeviceManufacturer2").should exist
  end

end