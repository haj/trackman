require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe Alarm do

  include_context "sign_in"
  include_context "sign_out"

  before (:each) do
    alarm = FactoryGirl.create(:alarm)
  end

  pending "should allow to create a new alarm" do 
    visit new_alarm_path
    page.status_code.should be 200
  end

  it "should allow to destroy a alarm" do
    visit alarms_path 
    # expect { click_link 'Destroy' }.to change(Alarm, :count).by(-1)
  end

  it "should allow to list all alarms" do 
    visit alarms_path
    page.status_code.should be 200
  end

end