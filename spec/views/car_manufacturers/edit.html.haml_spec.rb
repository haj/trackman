require 'spec_helper'

describe "car_manufacturers/edit" do
  before(:each) do
    @car_manufacturer = assign(:car_manufacturer, stub_model(CarManufacturer,
      :name => "MyString"
    ))
  end

  it "renders the edit car_manufacturer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", car_manufacturer_path(@car_manufacturer), "post" do
      assert_select "input#car_manufacturer_name[name=?]", "car_manufacturer[name]"
    end
  end
end
