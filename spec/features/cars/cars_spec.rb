require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "device management" do

    before (:each) do
      # seed a car model and a car type
      CarModel.create( id: 1, name: "Audi A2" )
      CarType.create( id: 1, name: "Sports Car" )

      # sign in manager
      @user = FactoryGirl.create(:manager) 
      login_as @user, scope: :user
      @user
    end

  it "should allow to create new car" do 
    visit new_car_path
    page.should have_content("Add car")
    fill_in "car_numberplate", :with => "211849"
    select  "Audi A2", :from => "car_car_model_id"
    select  "Sports Car", :from => "car_car_type_id"
    fill_in "car_registration_no", :with => "1"
    fill_in "car_year", :with => "1"
    click_button "Save"

    Car.where(numberplate: "211849").should exist
    page.should have_content("Car was successfully created")

  end

  it "should allow to destroy a car" do 
    visit cars_path
    page.should have_content('Sign out')
  end

  it "should allow to list all cars" do 
    visit cars_path
    page.should have_content('Sign out')
  end

  it "should allow to edit a car" do 
    visit cars_path
    page.should have_content('Sign out')
  end



end