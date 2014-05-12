require 'spec_helper'

describe "car_models/new" do
  before(:each) do
    assign(:car_model, stub_model(CarModel,
      :name => "MyString",
      :car_manufacturer_id => 1
    ).as_new_record)
  end

  it "renders new car_model form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", car_models_path, "post" do
      assert_select "input#car_model_name[name=?]", "car_model[name]"
      assert_select "input#car_model_car_manufacturer_id[name=?]", "car_model[car_manufacturer_id]"
    end
  end
end
