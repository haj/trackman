require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "plans management" do

    before (:each) do
      plan = FactoryGirl.create(:plan)
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      user
    end

  it "should allow to create new plan" do     
    visit new_plan_path
    page.should have_css('#plan_name')

    fill_in "plan_name", :with => "NewPlan"
    click_button "Save"

    Plan.where(name: "NewPlan").should exist
    page.should have_content("Plan was successfully created")
  end

  it "should allow to destroy a plan" do 
    visit plans_path
    expect { click_link 'Destroy' }.to change(Plan, :count).by(-1)
  end

  it "should allow to list all plan" do 
    visit plans_path
    page.should have_content('NewPlanType')
  end

  it "should allow to edit a plan" do 
    visit edit_plan_path(Plan.first)
    page.should have_css('#plan_name')

    fill_in "plan_name", :with => "NewPlanType"
    click_button "Save"

    Plan.where(name: "NewPlanType").should_not exist
    Plan.where(name: "NewPlanType2").should exist
  end

end