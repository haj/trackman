require 'spec_helper'

describe "device_models/edit" do
  before(:each) do
    @device_model = assign(:device_model, stub_model(DeviceModel,
      :name => "MyString",
      :device_manufacturer_id => 1,
      :protocol => "MyString"
    ))
  end

  it "renders the edit device_model form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", device_model_path(@device_model), "post" do
      assert_select "input#device_model_name[name=?]", "device_model[name]"
      assert_select "input#device_model_device_manufacturer_id[name=?]", "device_model[device_manufacturer_id]"
      assert_select "input#device_model_protocol[name=?]", "device_model[protocol]"
    end
  end
end
