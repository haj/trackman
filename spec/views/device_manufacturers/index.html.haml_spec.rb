require 'spec_helper'

describe "device_manufacturers/index" do
  before(:each) do
    assign(:device_manufacturers, [
      stub_model(DeviceManufacturer,
        :name => "Name"
      ),
      stub_model(DeviceManufacturer,
        :name => "Name"
      )
    ])
  end

  it "renders a list of device_manufacturers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
