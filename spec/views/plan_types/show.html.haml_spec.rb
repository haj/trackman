require 'spec_helper'

describe "plan_types/show" do
  before(:each) do
    @plan_type = assign(:plan_type, stub_model(PlanType))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
