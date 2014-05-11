require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "admin can edit companies" do

    before (:each) do
      #create second company
      tenant = Tenant.create(name: "CompanyA")
      Tenant.set_current_tenant(tenant.id)
      @user = FactoryGirl.create(:manager)
      @account = FactoryGirl.create(:account)

      # create current tenant and admin user
      tenant = Tenant.create(name: "CC")
      Tenant.set_current_tenant(tenant.id)
      @user = FactoryGirl.create(:admin)
      @account = FactoryGirl.create(:account)
      login_as(@user, :scope => :user)
    end

  it "should list a bunch of cars" do
    puts "MEMBER #{@user.member.first_name}"
    visit "/cars"
    page.should have_content("Cars")
  end

  it "the user should be connected" do 
    visit "/cars"
    page.should have_content("Logout")
  end

end