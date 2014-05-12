require 'spec_helper'

describe "car_manufacturers/new" do
  before(:each) do
    assign(:car_manufacturer, stub_model(CarManufacturer,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new car_manufacturer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", car_manufacturers_path, "post" do
      assert_select "input#car_manufacturer_name[name=?]", "car_manufacturer[name]"
    end
  end
end
