require 'spec_helper'

describe "cars/show" do
  before(:each) do
    @car = assign(:car, stub_model(Car,
      :mileage => 1.5,
      :numberplate => "Numberplate",
      :car_model_id => 1,
      :car_type_id => 2,
      :registration_no => "Registration No",
      :year => 3,
      :color => "Color",
      :group_id => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    rendered.should match(/Numberplate/)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Registration No/)
    rendered.should match(/3/)
    rendered.should match(/Color/)
    rendered.should match(/4/)
  end
end
