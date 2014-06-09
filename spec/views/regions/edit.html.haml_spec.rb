require 'spec_helper'

describe "regions/edit" do
  before(:each) do
    @region = assign(:region, stub_model(Region,
      :name => "MyString"
    ))
  end

  it "renders the edit region form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", region_path(@region), "post" do
      assert_select "input#region_name[name=?]", "region[name]"
    end
  end
end
