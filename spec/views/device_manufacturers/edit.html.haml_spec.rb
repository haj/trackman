require 'spec_helper'

describe "device_manufacturers/edit" do
  before(:each) do
    @device_manufacturer = assign(:device_manufacturer, stub_model(DeviceManufacturer,
      :name => "MyString"
    ))
  end

  it "renders the edit device_manufacturer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", device_manufacturer_path(@device_manufacturer), "post" do
      assert_select "input#device_manufacturer_name[name=?]", "device_manufacturer[name]"
    end
  end
end
