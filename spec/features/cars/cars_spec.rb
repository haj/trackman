require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "device management" do

    before (:each) do
      # Sign in manager
      user = FactoryGirl.create(:admin) 
      login_as user, scope: :user
      ActsAsTenant.current_tenant = Company.first
      car = FactoryGirl.create(:car)
    end

    after(:all) do
      ActsAsTenant.current_tenant = nil 
    end

  it "should allow to create new car" do 
    visit new_car_path
    page.should have_content("Sign out")
    fill_in "car_name", :with => "NewCar"
    fill_in "car_numberplate", :with => "211849"
    fill_in "car_mileage", :with => "1"
    fill_in "car_registration_no", :with => "1"
    fill_in "car_color", :with => "Red"
    fill_in "car_year", :with => "1"
    click_button "Save"

    #Car.where(numberplate: "211849").count.should_not eq(0)
    page.should have_content("was successfully created")
  end




  it "should allow to destroy a car" do 
    visit cars_path 
    #expect { click_link 'Destroy' }.to change(Car, :count).by(-1)
  end

  it "should allow to list all cars" do 
    visit cars_path
    page.should have_content('Vehicles')
  end

  it "should allow to edit a car model" do 
    visit edit_car_path(Car.first)

    fill_in "car_numberplate", :with => "NewCar2"
    click_button "Save"

    Car.where(numberplate: "NewCar").should_not exist
    Car.where(numberplate: "NewCar2").should exist
    page.should have_content('Sign out')
  end



end