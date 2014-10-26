require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "device management" do

    before (:each) do
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      ActsAsTenant.current_tenant = Company.first
      device = FactoryGirl.create(:device)
    end

    after(:each) do
      ActsAsTenant.current_tenant = nil 
    end

  it "should allow to create new device" do     
    visit new_device_path
    page.status_code.should be 200
    # page.should have_css('#device_name')

    # fill_in "device_name", :with => "NewDevice"
    # click_button "Save"

    # Device.where(name: "NewDevice").should exist
    # page.should have_content("Device was successfully created")
  end

  it "should allow to destroy a device" do 
    visit devices_path
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(Device, :count).by(-1)
  end

  it "should allow to list all devices" do 
    visit devices_path
    page.status_code.should be 200
    # page.should have_content('NewDevice')
  end

  it "should allow to edit a device" do 
    visit edit_device_path(Device.first)
    page.status_code.should be 200
    # page.should have_css('#device_name')

    # fill_in "device_name", :with => "NewDevice"
    # click_button "Save"

    # Device.where(name: "NewDevice").should_not exist
    # Device.where(name: "NewDevice").should exist
  end

end