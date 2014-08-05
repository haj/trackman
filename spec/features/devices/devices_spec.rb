require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "device management" do

    before (:each) do
      device = FactoryGirl.create(:device)
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      user
    end

  it "should allow to create new device" do     
    visit new_device_path
    page.should have_css('#device_name')

    fill_in "device_name", :with => "NewDevice"
    click_button "Save"

    Device.where(name: "NewDevice").should exist
    page.should have_content("Device was successfully created")
  end

  it "should allow to destroy a device" do 
    visit devices_path
    expect { click_link 'Destroy' }.to change(Device, :count).by(-1)
  end

  it "should allow to list all devices" do 
    visit devices_path
    page.should have_content('NewDevice')
  end

  it "should allow to edit a device" do 
    visit edit_device_path(Device.first)
    page.should have_css('#device_name')

    fill_in "device_name", :with => "NewDevice"
    click_button "Save"

    Device.where(name: "NewDevice").should_not exist
    Device.where(name: "NewDevice").should exist
  end

end