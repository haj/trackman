require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "device management" do

    before (:each) do
      @user = FactoryGirl.create(:manager) 
      login_as @user, scope: :user
      #@user
      ActsAsTenant.current_tenant = Company.first
    end

    after(:each) do
      ActsAsTenant.current_tenant = nil 
    end

  it "should allow to destroy a company" do 
    visit companies_path
    page.should have_content('Sign out')
  end

  it "should allow to list all companies" do 
    visit companies_path
    page.should have_content('Sign out')
  end

end