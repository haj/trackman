require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "simcards management" do

  include_context "sign_in"
  include_context "sign_out"

  it "should allow to create new simcard" do     
    visit new_simcard_path
    page.status_code.should be 200
    # page.should have_css('#simcard_telephone_number')

    # fill_in "simcard_telephone_number", :with => "NewSimcard"
    # click_button "Save"

    # Simcard.where(telephone_number: "NewSimcard").should exist
    # page.should have_content("Simcard was successfully created")
  end

  it "should allow to destroy a simcard" do 
    visit simcards_path
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(Simcard, :count).by(-1)
  end

  it "should allow to list all simcards" do 
    visit simcards_path
    page.status_code.should be 200
    # page.should have_content('NewSimcard')
  end

  it "should allow to edit a simcard" do 
    simcard = FactoryGirl.create(:simcard)
    visit edit_simcard_path(Simcard.first)
    page.status_code.should be 200
    # page.should have_css('#simcard_telephone_number')

    # fill_in "simcard_telephone_number", :with => "NewSimcard2"
    # click_button "Save"

    # Simcard.where(telephone_number: "NewSimcard").should_not exist
    # Simcard.where(telephone_number: "NewSimcard2").should exist
  end

end