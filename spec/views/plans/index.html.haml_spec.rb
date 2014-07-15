require 'spec_helper'

describe "plans/index" do
  before(:each) do
    assign(:plans, [
      stub_model(Plan),
      stub_model(Plan)
    ])
  end

  it "renders a list of plans" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
