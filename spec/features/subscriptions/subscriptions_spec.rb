require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "subscriptions management" do

    before (:each) do
      subscription = FactoryGirl.create(:subscription)
      user = FactoryGirl.create(:manager) 
      login_as user, scope: :user
      user
    end

  it "should allow to create new subscription" do     
    visit new_subscription_path
    page.should have_css('#subscription_name')

    fill_in "subscription_name", :with => "NewSubscription"
    click_button "Save"

    Subscription.where(name: "NewSubscription").should exist
    page.should have_content("Subscription was successfully created")
  end

  it "should allow to destroy a subscription" do 
    visit subscriptions_path
    expect { click_link 'Destroy' }.to change(Subscription, :count).by(-1)
  end

  it "should allow to list all subscriptions" do 
    visit subscriptions_path
    page.should have_content('NewSubscription')
  end

  it "should allow to edit a subscription" do 
    visit edit_subscription_path(Subscription.first)
    page.should have_css('#subscription_name')

    fill_in "subscription_name", :with => "NewSubscription"
    click_button "Save"

    Subscription.where(name: "NewSubscription").should_not exist
    Subscription.where(name: "NewSubscription2").should exist
  end

end