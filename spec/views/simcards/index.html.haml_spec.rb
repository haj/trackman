require 'spec_helper'

describe "simcards/index" do
  before(:each) do
    assign(:simcards, [
      stub_model(Simcard,
        :telephone_number => "Telephone Number",
        :teleprovider_id => 1,
        :monthly_price => 1.5,
        :device_id => 2
      ),
      stub_model(Simcard,
        :telephone_number => "Telephone Number",
        :teleprovider_id => 1,
        :monthly_price => 1.5,
        :device_id => 2
      )
    ])
  end

  it "renders a list of simcards" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Telephone Number".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
