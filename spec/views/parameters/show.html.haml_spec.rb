require 'spec_helper'

describe "parameters/show" do
  before(:each) do
    @parameter = assign(:parameter, stub_model(Parameter,
      :name => "Name",
      :type => "Type",
      :rule_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Type/)
    rendered.should match(/1/)
  end
end
