require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe Device do

  before (:each) do
    Traccar::User.create!({admin: true, login: "admin", password: "admin", userSettings_id: nil})    
    device = FactoryGirl.create(:device)
  end

  it "Can be created", focus: true do     
    visit new_device_path
    fill_in "device_name", :with => "OldDevice"
    fill_in "device_emei", :with => "123456"
    select  "DeviceModel A", :from => "device_device_model_id"
    select  "DeviceType 1", :from => "device_device_type_id"
    fill_in "device_cost_price", :with => "12"
    click_button "Save"
    Device.where(name: "OldDevice").first.should_not be_nil
    page.should have_content("was successfully created")
  end

  it "can be destroyed" do 
    visit devices_path
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(Device, :count).by(-1)
  end

  it "can be listed" do 
    visit devices_path
    page.status_code.should be 200
    page.should have_content('Devices')
  end

  it "can be updated" do 
    visit edit_device_path(Device.first)

    fill_in "device_name", :with => "NewDevice"
    click_button "Save"

    page.should have_content('Sign out')
    Device.where(name: "OldDevice").should_not exist
    Device.where(name: "NewDevice").should exist
  end

end