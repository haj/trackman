require 'spec_helper'

describe "car_types/new" do
  before(:each) do
    assign(:car_type, stub_model(CarType,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new car_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", car_types_path, "post" do
      assert_select "input#car_type_name[name=?]", "car_type[name]"
    end
  end
end
