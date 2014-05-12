require 'spec_helper'

describe "car_types/index" do
  before(:each) do
    assign(:car_types, [
      stub_model(CarType,
        :name => "Name"
      ),
      stub_model(CarType,
        :name => "Name"
      )
    ])
  end

  it "renders a list of car_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
