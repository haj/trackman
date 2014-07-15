require 'spec_helper'

describe "plan_types/new" do
  before(:each) do
    assign(:plan_type, stub_model(PlanType).as_new_record)
  end

  it "renders new plan_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", plan_types_path, "post" do
    end
  end
end
