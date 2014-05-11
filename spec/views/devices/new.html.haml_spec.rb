require 'spec_helper'

describe "devices/new" do
  before(:each) do
    assign(:device, stub_model(Device,
      :name => "MyString",
      :emei => "MyString",
      :cost_price => 1.5
    ).as_new_record)
  end

  it "renders new device form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", devices_path, "post" do
      assert_select "input#device_name[name=?]", "device[name]"
      assert_select "input#device_emei[name=?]", "device[emei]"
      assert_select "input#device_cost_price[name=?]", "device[cost_price]"
    end
  end
end
