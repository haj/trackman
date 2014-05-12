require 'spec_helper'

describe "device_types/edit" do
  before(:each) do
    @device_type = assign(:device_type, stub_model(DeviceType,
      :name => "MyString"
    ))
  end

  it "renders the edit device_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", device_type_path(@device_type), "post" do
      assert_select "input#device_type_name[name=?]", "device_type[name]"
    end
  end
end
