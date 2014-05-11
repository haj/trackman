require "spec_helper"

describe "user registration" do

  it "allows new users to register companies" do
    visit "/users/sign_up"

    fill_in "Email",                 :with => "test@example.com"
    fill_in "Password",              :with => "testpassword"
    fill_in "user_password_confirmation", :with => "testpassword"
    fill_in "Name", :with => "corp"
    fill_in "Subdomain", :with => "corp"

    click_button "Sign up"

    page.should have_content("Welcome! You have signed up successfully")
  end

  it "password and password confirmation should match" do
    visit "/users/sign_up"

    fill_in "Email",                 :with => "test@example.com"
    fill_in "Password",              :with => "testpassword"
    fill_in "user_password_confirmation", :with => "some_other_password"

    click_button "Sign up"
	page.should have_content("1 error prohibited this user from being saved: Password confirmation doesn't match Password")
  end


  it "should have email input field" do 
  	visit "/users/sign_up"
  	page.should have_content('Email')
  end


  it "should have password input field" do 
  	visit "/users/sign_up"
  	page.should have_content('Password')
  end

  it "should have password confirmation field" do 
  	visit "/users/sign_up"
  	page.should have_content('Password confirmation')
  end

end