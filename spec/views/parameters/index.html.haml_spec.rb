require 'spec_helper'

describe "parameters/index" do
  before(:each) do
    assign(:parameters, [
      stub_model(Parameter,
        :name => "Name",
        :type => "Type",
        :rule_id => 1
      ),
      stub_model(Parameter,
        :name => "Name",
        :type => "Type",
        :rule_id => 1
      )
    ])
  end

  it "renders a list of parameters" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
