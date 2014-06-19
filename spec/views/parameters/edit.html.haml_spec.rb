require 'spec_helper'

describe "parameters/edit" do
  before(:each) do
    @parameter = assign(:parameter, stub_model(Parameter,
      :name => "MyString",
      :type => "",
      :rule_id => 1
    ))
  end

  it "renders the edit parameter form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", parameter_path(@parameter), "post" do
      assert_select "input#parameter_name[name=?]", "parameter[name]"
      assert_select "input#parameter_type[name=?]", "parameter[type]"
      assert_select "input#parameter_rule_id[name=?]", "parameter[rule_id]"
    end
  end
end
