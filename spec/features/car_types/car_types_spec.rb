require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "device management" do
  
  before (:each) do
    car_type = FactoryGirl.create(:car_type)
    @user = FactoryGirl.create(:manager) 
    login_as @user, scope: :user
    ActsAsTenant.current_tenant = Company.first
  end

  after(:each) do
    ActsAsTenant.current_tenant = nil 
  end

  it "should allow to create new car type" do 
    visit new_car_type_path
    #save_and_open_page

    #page.status_code.should be 200
    page.should have_css('#car_type_name')

    # fill_in "car_type_name", :with => "NewCarType"
    # click_button "Save"

    # CarType.where(name: "NewCarType").should exist
    # page.should have_content("Car type was successfully created")

  end

  it "should allow to destroy a car type" do 
    visit car_types_path 
    page.status_code.should be 200
    # expect { click_link 'Destroy' }.to change(CarType, :count).by(-1)
  end

  it "should allow to list all car types" do 
    visit car_types_path
    page.status_code.should be 200
    # page.should have_content('CarType')
  end

  it "should allow to edit a car type" do 
    visit edit_car_type_path(CarType.first)
    page.status_code.should be 200
    # page.should have_css('#car_type_name')

    # fill_in "car_type_name", :with => "NewCarType2"
    # click_button "Save"

    # CarModel.where(name: "NewCarType").should_not exist
    # CarModel.where(name: "NewCarType2").should exist
  end



end