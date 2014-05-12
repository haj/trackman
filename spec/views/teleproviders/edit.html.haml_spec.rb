require 'spec_helper'

describe "teleproviders/edit" do
  before(:each) do
    @teleprovider = assign(:teleprovider, stub_model(Teleprovider,
      :name => "MyString",
      :apn => "MyString"
    ))
  end

  it "renders the edit teleprovider form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", teleprovider_path(@teleprovider), "post" do
      assert_select "input#teleprovider_name[name=?]", "teleprovider[name]"
      assert_select "input#teleprovider_apn[name=?]", "teleprovider[apn]"
    end
  end
end
