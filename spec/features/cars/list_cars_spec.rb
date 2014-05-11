require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "manager can view cars" do

    before (:each) do
      tenant = Tenant.create(name: "CC")
      Tenant.set_current_tenant(tenant.id)
      @user = FactoryGirl.create(:manager)
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