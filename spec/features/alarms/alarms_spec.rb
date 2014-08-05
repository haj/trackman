require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Alarms management" do

    before (:each) do
      alarm = FactoryGirl.create(:alarm)
      @user = FactoryGirl.create(:manager) 
      login_as @user, scope: :user
      @user
    end

  pending "should allow to create a new alarm" do 
    visit new_alarm_path
    page.should have_content("New alarm")
    
    click_link "new_alarm"
    click_button "Save"

    Alarm.where(name: "New alarm").should exist
    page.should have_content("Alarm was successfully created")
  end

  it "should allow to destroy a alarm" do
    visit alarms_path 
    expect { click_link 'Destroy' }.to change(Alarm, :count).by(-1)
  end

  it "should allow to list all alarms" do 
    visit alarms_path
    page.should have_content("Alarm")
    page.should have_content('Sign out')
  end

end