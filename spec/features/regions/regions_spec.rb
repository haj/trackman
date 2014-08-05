require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Regions management" do

    before (:each) do
      region = FactoryGirl.create(:region)
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      user
    end

  it "should allow to create new region" do     
    visit new_region_path
    page.should have_css('#region_name')

    fill_in "region_name", :with => "NewRegion"
    click_button "Save"

    Region.where(name: "NewRegion").should exist
    page.should have_content("Region was successfully created")
  end

  it "should allow to destroy a region" do 
    visit regions_path
    expect { click_link 'Destroy' }.to change(Region, :count).by(-1)
  end

  it "should allow to list all region" do 
    visit regions_path
    page.should have_content('NewRegion')
  end

  it "should allow to edit a region" do 
    visit edit_region_path(Region.first)
    page.should have_css('#region_name')

    fill_in "region_name", :with => "NewRegion"
    click_button "Save"

    Region.where(name: "NewRegion").should_not exist
    Region.where(name: "NewRegion2").should exist
  end

end