require 'spec_helper'

describe "teleproviders/show" do
  before(:each) do
    @teleprovider = assign(:teleprovider, stub_model(Teleprovider,
      :name => "Name",
      :apn => "Apn"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Apn/)
  end
end
