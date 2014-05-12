require 'spec_helper'

describe "teleproviders/new" do
  before(:each) do
    assign(:teleprovider, stub_model(Teleprovider,
      :name => "MyString",
      :apn => "MyString"
    ).as_new_record)
  end

  it "renders new teleprovider form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", teleproviders_path, "post" do
      assert_select "input#teleprovider_name[name=?]", "teleprovider[name]"
      assert_select "input#teleprovider_apn[name=?]", "teleprovider[apn]"
    end
  end
end
