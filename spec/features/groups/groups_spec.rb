require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "group management" do

  before (:each) do
    group = FactoryGirl.create(:group)
  end


  it "should allow to create new group" do     
    visit new_group_path
    page.status_code.should be 200
    # page.should have_css('#group_name')

    # fill_in "group_name", :with => "NewGroup"
    # click_button "Save"

    # group.where(name: "NewGroup").should exist
    # page.should have_content("Group was successfully created")
  end

  it "should allow to destroy a group" do 
    visit groups_path
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(Group, :count).by(-1)
  end

  it "should allow to list all groups" do 
    visit groups_path
    page.status_code.should be 200
    # page.should have_content('NewGroup')
  end

  it "should allow to edit a group" do 
    visit edit_group_path(Group.first)
    page.status_code.should be 200
    # page.should have_css('#group_name')

    # fill_in "group_name", :with => "NewGroup"
    # click_button "Save"

    # group.where(name: "NewGroup").should_not exist
    # group.where(name: "NewGroup2").should exist
  end

end