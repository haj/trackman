# require "spec_helper"
# include Warden::Test::Helpers
# Warden.test_mode!

# describe "user sign in" do

#     before (:each) do
#       #@user_outside_company = FactoryGirl.create(:user)
#       @user = FactoryGirl.create(:user) 
#       #ActsAsTenant.current_tenant = @user.company
#     end

#   it "Should allow a valid email password combination" do 
#     visit "/users/sign_in"
#     fill_in "user_email", :with => @user.email
#     fill_in "user_password", :with => @user.password
#     click_button "sign-in"
#     page.should have_content('Sign out')
#   end

#   it "Shouldn't allow an invalid email password combination" do 
#     visit "/users/sign_in"
#     fill_in "user_email", :with => "@user.email"
#     fill_in "user_password", :with => "@user.password"
#     click_button "sign-in"
#     page.should_not have_content('Sign out')
#   end


# end