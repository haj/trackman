require 'spec_helper'

describe "device_manufacturers/show" do
  before(:each) do
    @device_manufacturer = assign(:device_manufacturer, stub_model(DeviceManufacturer,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
