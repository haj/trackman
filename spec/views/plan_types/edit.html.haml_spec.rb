require 'spec_helper'

describe "plan_types/edit" do
  before(:each) do
    @plan_type = assign(:plan_type, stub_model(PlanType))
  end

  it "renders the edit plan_type form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", plan_type_path(@plan_type), "post" do
    end
  end
end
