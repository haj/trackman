require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "user sign in" do

    before (:each) do
      #@user_outside_company = FactoryGirl.create(:user)
      @user = FactoryGirl.create(:user) 
      #ActsAsTenant.current_tenant = @user.company
    end

  it "should allow a valid email password combination" do 
    visit "users/sign_in"
    fill_in "Email", :with => @user.email
    fill_in "Password", :with => @user.password
    click_button "Sign in"
    page.should have_content('Logout')
  end

  it "shouldn't allow an invalid email password combination" do 
    visit "users/sign_in"
    fill_in "Email", :with => "@user.email"
    fill_in "Password", :with => "@user.password"
    click_button "Sign in"
    page.should_not have_content('Logout')
  end


  it "should have email input field" do 
  	visit "users/sign_in"
  	page.should have_content('Email')
  end


  it "should have password input field" do 
  	visit "users/sign_in"
  	page.should have_content('Password')
  end


end