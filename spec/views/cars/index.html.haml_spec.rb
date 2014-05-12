require 'spec_helper'

describe "cars/index" do
  before(:each) do
    assign(:cars, [
      stub_model(Car,
        :mileage => 1.5,
        :numberplate => "Numberplate",
        :car_model_id => 1,
        :car_type_id => 2,
        :registration_no => "Registration No",
        :year => 3,
        :color => "Color",
        :group_id => 4
      ),
      stub_model(Car,
        :mileage => 1.5,
        :numberplate => "Numberplate",
        :car_model_id => 1,
        :car_type_id => 2,
        :registration_no => "Registration No",
        :year => 3,
        :color => "Color",
        :group_id => 4
      )
    ])
  end

  it "renders a list of cars" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Numberplate".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Registration No".to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => "Color".to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
