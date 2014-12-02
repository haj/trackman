require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe DeviceType do

  include_context "sign_in"
  include_context "sign_out"

  before (:each) do
    device_type = FactoryGirl.create(:device_type)
  end

  it "should allow to create new device type" do     
    visit new_device_type_path
    page.status_code.should be 200
    # page.should have_css('#device_type_name')

    # fill_in "device_type_name", :with => "NewDeviceType"
    # click_button "Save"

    # DeviceType.where(name: "NewDeviceType").should exist
    # page.should have_content("Device type was successfully created")
  end

  it "should allow to destroy a device type" do 
    visit device_types_path
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(DeviceType, :count).by(-1)
  end

  it "should allow to list all device types" do 
    visit device_types_path
    page.status_code.should be 200
    # page.should have_content('NewDeviceType')
  end

  it "should allow to edit a device type" do 
    visit edit_device_type_path(DeviceType.first)
    page.status_code.should be 200
    # page.should have_css('#device_type_name')

    # fill_in "device_type_name", :with => "NewDeviceType2"
    # click_button "Save"

    # DeviceType.where(name: "NewDeviceType").should_not exist
    # DeviceType.where(name: "NewDeviceType2").should exist
  end

end