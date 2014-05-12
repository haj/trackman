require 'spec_helper'

describe "device_types/show" do
  before(:each) do
    @device_type = assign(:device_type, stub_model(DeviceType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
