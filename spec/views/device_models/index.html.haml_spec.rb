require 'spec_helper'

describe "device_models/index" do
  before(:each) do
    assign(:device_models, [
      stub_model(DeviceModel,
        :name => "Name",
        :device_manufacturer_id => 1,
        :protocol => "Protocol"
      ),
      stub_model(DeviceModel,
        :name => "Name",
        :device_manufacturer_id => 1,
        :protocol => "Protocol"
      )
    ])
  end

  it "renders a list of device_models" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Protocol".to_s, :count => 2
  end
end
