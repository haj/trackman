require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Simcards management" do

    before (:each) do
      @user = FactoryGirl.create(:manager) 
      login_as @user, scope: :user
      @user
    end

  it "should allow to create new simcard" do 
    visit new_simcard_path
    page.should have_css('#simcard_name')

    fill_in "device_name", :with => "device1"
    fill_in "device_emei", :with => "testemei"
    fill_in "device_name", :with => "device1"
    click_button "Save"

    Device.where(emei: "testemei").should exist
    Traccar::Device.where(uniqueId: "testemei").should exist

    page.should have_content("Device was successfully created")

  end

  it "should allow to list all simcards" do 
    visit simcards_path
    page.should have_content('Sign out')
  end

  it "should allow to destroy a simcard" do 
    visit simcards_path
    page.should have_content('Sign out')
  end

  it "should allow to edit a simcard" do 
    visit simcards_path
    page.should have_content('Sign out')
  end



end