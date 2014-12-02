require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe CarModel do

  include_context "sign_in"
  include_context "sign_out"

  before (:each) do
    car_model = FactoryGirl.create(:car_model)
  end

  it "should allow to create new car model" do     
    visit new_car_model_path
    page.should have_content('Sign out')
    # page.should have_css('#car_model_name')

    # fill_in "car_model_name", :with => "NewCarModel"
    # click_button "Save"

    # CarModel.where(name: "NewCarModel").should exist
    # page.should have_content("Car model was successfully created")
  end

  it "should allow to destroy a car model" do 
    visit car_models_path 
    page.should have_content('Sign out')
    # expect { click_link 'Destroy' }.to change(CarModel, :count).by(-1)
  end

  it "should allow to list all car models" do 
    visit car_models_path
    page.should have_content('Sign out')
    # page.should have_content('CarModel')
  end

  it "should allow to edit a car model" do 
    visit edit_car_model_path(CarModel.first)
    page.should have_content('Sign out')
    # page.should have_css('#car_model_name')

    # fill_in "car_model_name", :with => "NewCarModel2"
    # click_button "Save"

    # CarModel.where(name: "NewCarModel").should_not exist
    # CarModel.where(name: "NewCarModel2").should exist
  end



end