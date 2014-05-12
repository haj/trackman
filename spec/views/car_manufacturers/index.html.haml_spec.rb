require 'spec_helper'

describe "car_manufacturers/index" do
  before(:each) do
    assign(:car_manufacturers, [
      stub_model(CarManufacturer,
        :name => "Name"
      ),
      stub_model(CarManufacturer,
        :name => "Name"
      )
    ])
  end

  it "renders a list of car_manufacturers" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
