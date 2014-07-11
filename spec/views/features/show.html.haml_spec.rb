require 'spec_helper'

describe "features/show" do
  before(:each) do
    @feature = assign(:feature, stub_model(Feature,
      :name => "Name",
      :role => "Role"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Role/)
  end
end
