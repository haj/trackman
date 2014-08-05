require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Plan types management" do

    before (:each) do
      plan_type = FactoryGirl.create(:plan_type)
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      user
    end

  it "should allow to create new plan_type" do     
    visit new_plan_type_path
    page.should have_css('#plan_type_name')

    fill_in "plan_type_name", :with => "NewPlanType"
    click_button "Save"

    PlanType.where(name: "NewPlanType").should exist
    page.should have_content("Plan type was successfully created")
  end

  it "should allow to destroy a plan type" do 
    visit plan_types_path
    expect { click_link 'Destroy' }.to change(PlanType, :count).by(-1)
  end

  it "should allow to list all plan types" do 
    visit plan_types_path
    page.should have_content('NewPlanType')
  end

  it "should allow to edit a plan type" do 
    visit edit_plan_type_path(PlanType.first)
    page.should have_css('#plan_type_name')

    fill_in "plan_type_name", :with => "NewPlanType"
    click_button "Save"

    PlanType.where(name: "NewPlanType").should_not exist
    PlanType.where(name: "NewPlanType2").should exist
  end

end