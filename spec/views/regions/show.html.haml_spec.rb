require 'spec_helper'

describe "regions/show" do
  before(:each) do
    @region = assign(:region, stub_model(Region,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
