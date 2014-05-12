require 'spec_helper'

describe "device_manufacturers/new" do
  before(:each) do
    assign(:device_manufacturer, stub_model(DeviceManufacturer,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new device_manufacturer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", device_manufacturers_path, "post" do
      assert_select "input#device_manufacturer_name[name=?]", "device_manufacturer[name]"
    end
  end
end
