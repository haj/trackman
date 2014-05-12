require 'spec_helper'

describe "teleproviders/index" do
  before(:each) do
    assign(:teleproviders, [
      stub_model(Teleprovider,
        :name => "Name",
        :apn => "Apn"
      ),
      stub_model(Teleprovider,
        :name => "Name",
        :apn => "Apn"
      )
    ])
  end

  it "renders a list of teleproviders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Apn".to_s, :count => 2
  end
end
