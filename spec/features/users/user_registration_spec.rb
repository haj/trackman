require "spec_helper"

describe "User Registration" do

	include_context "sign_out"

	it "allows new users to register companies" do
		visit new_user_registration_path
		fill_in "user_first_name",            :with => "zak"
		fill_in "user_last_name",             :with => "bk"    
		fill_in "user_email",                 :with => "test@example.com"
		fill_in "user_password",              :with => "testpassword"
		fill_in "user_password_confirmation", :with => "testpassword"
		fill_in "company_name",               :with => "corp"
		fill_in "company_subdomain",          :with => "corp"
		click_button "Sign up"
		User.where(email: "test@example.com").should exist
		Company.where(subdomain: "corp").should exist
		page.should have_content("Sign in")
	end

	it "password and password confirmation should match" do  
		visit new_user_registration_path
		fill_in "user_email",                 :with => "test@example.com"
		fill_in "user_password",              :with => "testpassword"
		fill_in "user_password_confirmation", :with => "some_other_password"
		click_button "Sign up"
		page.should have_content("1 error prohibited this user from being saved: Password confirmation doesn't match Password")
	end


end