require 'spec_helper'

describe "device_types/index" do
  before(:each) do
    assign(:device_types, [
      stub_model(DeviceType,
        :name => "Name"
      ),
      stub_model(DeviceType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of device_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
