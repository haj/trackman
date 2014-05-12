require 'spec_helper'

describe "device_types/new" do
  before(:each) do
    assign(:device_type, stub_model(DeviceType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new device_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", device_types_path, "post" do
      assert_select "input#device_type_name[name=?]", "device_type[name]"
    end
  end
end
