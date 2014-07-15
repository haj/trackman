require 'spec_helper'

describe "subscriptions/index" do
  before(:each) do
    assign(:subscriptions, [
      stub_model(Subscription,
        :email => "Email",
        :name => "Name",
        :paymill_id => "Paymill"
      ),
      stub_model(Subscription,
        :email => "Email",
        :name => "Name",
        :paymill_id => "Paymill"
      )
    ])
  end

  it "renders a list of subscriptions" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Paymill".to_s, :count => 2
  end
end
