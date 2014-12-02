require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Rules management" do

  include_context "sign_in"
  include_context "sign_out"

  before (:each) do
    rule = FactoryGirl.create(:rule)
  end

  it "should allow to create new rule" do     
    visit new_rule_path
    page.status_code.should be 200
    # page.should have_css('#rule_name')

    # fill_in "rule_name", :with => "NewRule"
    # click_button "Save"

    # Rule.where(name: "NewRule").should exist
    # page.should have_content("Rule was successfully created")
  end

  it "should allow to destroy a rule" do 
    visit rules_path
    # expect { click_link 'Destroy' }.to change(Rule, :count).by(-1)
  end

  it "should allow to list all rule" do 
    visit rules_path
    page.status_code.should be 200
    # page.should have_content('NewRule')
  end

  it "should allow to edit a rule" do 
    visit edit_rule_path(Rule.first)
    page.status_code.should be 200
    # page.should have_css('#rule_name')

    # fill_in "rule_name", :with => "NewRule"
    # click_button "Save"

    # Rule.where(name: "NewRule").should_not exist
    # Rule.where(name: "NewRule2").should exist
  end

end