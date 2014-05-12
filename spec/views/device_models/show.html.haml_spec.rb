require 'spec_helper'

describe "device_models/show" do
  before(:each) do
    @device_model = assign(:device_model, stub_model(DeviceModel,
      :name => "Name",
      :device_manufacturer_id => 1,
      :protocol => "Protocol"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/1/)
    rendered.should match(/Protocol/)
  end
end
