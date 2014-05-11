require 'spec_helper'

describe "devices/edit" do
  before(:each) do
    @device = assign(:device, stub_model(Device,
      :name => "MyString",
      :emei => "MyString",
      :cost_price => 1.5
    ))
  end

  it "renders the edit device form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", device_path(@device), "post" do
      assert_select "input#device_name[name=?]", "device[name]"
      assert_select "input#device_emei[name=?]", "device[emei]"
      assert_select "input#device_cost_price[name=?]", "device[cost_price]"
    end
  end
end
