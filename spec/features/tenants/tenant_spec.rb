require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Tenancy" do

  before (:each) do
    logout(:user)
    @user = FactoryGirl.create(:user) 
  end

  it "Should allow a valid email password combination" do 
    visit new_user_session_path
    fill_in "user_email", :with => @user.email
    fill_in "user_password", :with => @user.password
    click_button "sign-in"
    page.should have_content('Sign out')
  end

  it "Shouldn't allow an invalid email password combination" do 
    visit new_user_session_path
    fill_in "user_email", :with => "@user.email"
    fill_in "user_password", :with => "@user.password"
    click_button "sign-in"
    page.should_not have_content('Sign out')
  end


end