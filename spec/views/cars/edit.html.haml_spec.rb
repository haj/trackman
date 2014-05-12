require 'spec_helper'

describe "cars/edit" do
  before(:each) do
    @car = assign(:car, stub_model(Car,
      :mileage => 1.5,
      :numberplate => "MyString",
      :car_model_id => 1,
      :car_type_id => 1,
      :registration_no => "MyString",
      :year => 1,
      :color => "MyString",
      :group_id => 1
    ))
  end

  it "renders the edit car form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", car_path(@car), "post" do
      assert_select "input#car_mileage[name=?]", "car[mileage]"
      assert_select "input#car_numberplate[name=?]", "car[numberplate]"
      assert_select "input#car_car_model_id[name=?]", "car[car_model_id]"
      assert_select "input#car_car_type_id[name=?]", "car[car_type_id]"
      assert_select "input#car_registration_no[name=?]", "car[registration_no]"
      assert_select "input#car_year[name=?]", "car[year]"
      assert_select "input#car_color[name=?]", "car[color]"
      assert_select "input#car_group_id[name=?]", "car[group_id]"
    end
  end
end
