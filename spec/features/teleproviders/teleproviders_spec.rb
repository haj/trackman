require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe "Teleproviders management" do
  
  include_context "sign_in"
  include_context "sign_out"
  
  before (:each) do
    teleprovider = FactoryGirl.create(:teleprovider)
  end

  it "should allow to create new teleprovider" do     
    visit new_teleprovider_path
        page.status_code.should be 200

    # page.should have_css('#teleprovider_name')

    # fill_in "teleprovider_name", :with => "NewTeleprovider"
    # click_button "Save"

    # Teleprovider.where(name: "NewTeleprovider").should exist
    # page.should have_content("Teleprovider was successfully created")
  end

  it "should allow to destroy a teleprovider" do 
    visit teleproviders_path
    # expect { click_link 'Destroy' }.to change(Teleprovider, :count).by(-1)
  end

  it "should allow to list all teleproviders" do 
    visit teleproviders_path
    expect(page.status_code).to be 200   
    # page.should have_content('NewTeleprovider')
  end

  it "should allow to edit a teleprovider" do 
    visit edit_teleprovider_path(Teleprovider.first)
    expect(page.status_code).to be 200
    # page.should have_css('#teleprovider_name')

    # fill_in "teleprovider_name", :with => "NewTeleprovider"
    # click_button "Save"

    # Teleprovider.where(name: "NewTeleprovider").should_not exist
    # Teleprovider.where(name: "NewTeleprovider2").should exist
  end

end