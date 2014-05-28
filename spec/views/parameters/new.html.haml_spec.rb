require 'spec_helper'

describe "parameters/new" do
  before(:each) do
    assign(:parameter, stub_model(Parameter,
      :name => "MyString",
      :type => "",
      :rule_id => 1
    ).as_new_record)
  end

  it "renders new parameter form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", parameters_path, "post" do
      assert_select "input#parameter_name[name=?]", "parameter[name]"
      assert_select "input#parameter_type[name=?]", "parameter[type]"
      assert_select "input#parameter_rule_id[name=?]", "parameter[rule_id]"
    end
  end
end
