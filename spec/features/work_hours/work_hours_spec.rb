require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "work_hours management" do

    before (:each) do
      work_hour = FactoryGirl.create(:work_hour)
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      user
    end

  it "should allow to create new work_hour" do     
    visit new_work_hour_path
    page.should have_css('#work_hour_name')

    fill_in "work_hour_name", :with => "NewWorkHour"
    click_button "Save"

    Work.where(name: "NewWorkHour").should exist
    page.should have_content("Work hour was successfully created")
  end

  it "should allow to destroy a work_hour" do 
    visit work_hours_path
    expect { click_link 'Destroy' }.to change(Work, :count).by(-1)
  end

  it "should allow to list all work_hours" do 
    visit work_hours_path
    page.should have_content('NewWorkHour')
  end

  it "should allow to edit a work_hour" do 
    visit edit_work_hour_path(Work.first)
    page.should have_css('#work_hour_name')

    fill_in "work_hour_name", :with => "NewWorkHour"
    click_button "Save"

    Work.where(name: "NewWorkHour").should_not exist
    Work.where(name: "NewWorkHour2").should exist
  end

end