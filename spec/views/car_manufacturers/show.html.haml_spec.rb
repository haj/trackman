require 'spec_helper'

describe "car_manufacturers/show" do
  before(:each) do
    @car_manufacturer = assign(:car_manufacturer, stub_model(CarManufacturer,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
