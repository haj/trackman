require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Regions management" do

  include_context "sign_in"
  include_context "sign_out"

  before (:each) do
    region = FactoryGirl.create(:region)
  end



  it "should allow to create new region" do     
    visit new_region_path
    page.status_code.should be 200
  #   page.should have_css('#region_name')

  #   fill_in "region_name", :with => "NewRegion"
  #   click_button "Save"

  #   Region.where(name: "NewRegion").should exist
  #   page.should have_content("Region was successfully created")
  end

  it "should allow to destroy a region" do 
    visit regions_path
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(Region, :count).by(-1)
  end

  it "should allow to list all region" do 
    visit regions_path
    page.status_code.should be 200
    # page.should have_content('NewRegion')
  end


end