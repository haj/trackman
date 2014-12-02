require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe Car do

  include_context "sign_in"
  include_context "sign_out"

  before (:each) do
    car = FactoryGirl.create(:car)
  end

  it "should allow to create new car" do 
    visit new_car_path
    page.should have_content("Sign out")
    fill_in "car_name", :with => "OldCar"
    fill_in "car_numberplate", :with => "211849"
    fill_in "car_mileage", :with => "1"
    fill_in "car_registration_no", :with => "1"
    fill_in "car_color", :with => "Red"
    fill_in "car_year", :with => "1"
    click_button "Save"

    #Car.where(numberplate: "211849").count.should_not eq(0)
    page.should have_content("was successfully created")
  end

  it "should link car with device" do 
    visit new_car_path
    page.should have_content("Sign out")
    fill_in "car_name", :with => "OldCar"
    fill_in "car_numberplate", :with => "211849"
    fill_in "car_mileage", :with => "1"
    fill_in "car_registration_no", :with => "1"
    fill_in "car_color", :with => "Red"
    fill_in "car_year", :with => "1"
    click_button "Save"

    #Car.where(numberplate: "211849").count.should_not eq(0)
    page.should have_content("was successfully created")

    visit new_device_path
    fill_in "device_name", :with => "OldDevice"
    fill_in "device_emei", :with => "123456"
    select  "DeviceModel A", :from => "device_device_model_id"
    select  "DeviceType 1", :from => "device_device_type_id"
    fill_in "device_cost_price", :with => "12"
    click_button "Save"

    

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

    fill_in "car_numberplate", :with => "NewCar"
    click_button "Save"

    Car.where(numberplate: "OldCar").should_not exist
    Car.where(numberplate: "NewCar").should exist
  end



end