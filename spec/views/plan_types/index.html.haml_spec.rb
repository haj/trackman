require 'spec_helper'

describe "plan_types/index" do
  before(:each) do
    assign(:plan_types, [
      stub_model(PlanType),
      stub_model(PlanType)
    ])
  end

  it "renders a list of plan_types" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
