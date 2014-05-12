require 'spec_helper'

describe "car_types/show" do
  before(:each) do
    @car_type = assign(:car_type, stub_model(CarType,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
