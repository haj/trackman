require 'spec_helper'

describe "plans/edit" do
  before(:each) do
    @plan = assign(:plan, stub_model(Plan))
  end

  it "renders the edit plan form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", plan_path(@plan), "post" do
    end
  end
end
