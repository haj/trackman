require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "User Sign in" do

	before (:each) do
	  logout(:user)
	  ActsAsTenant.current_tenant = Company.first
	  @user = FactoryGirl.create(:user) 	  
	end

	it "shouldn't work if user in wrong subdomain", focus: true do 
		FactoryGirl.create(:company, name: "haha", subdomain: "haha")
		Capybara.default_host = 'http://haha.trackman.dev'
		visit new_user_session_path
		fill_in "user_email", :with => @user.email
		fill_in "user_password", :with => @user.password
		click_button "sign-in"
		page.should have_content('Sign in')
	end

	pending "should work if user is connecting through the correct subdomain" do
		Capybara.default_host = 'http://demo.trackman.dev'
		visit new_user_session_path
		fill_in "user_email", :with => @user.email
		fill_in "user_password", :with => @user.password
		click_button "sign-in"
		page.should have_content('Sign out')
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