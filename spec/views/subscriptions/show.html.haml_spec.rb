require 'spec_helper'

describe "subscriptions/show" do
  before(:each) do
    @subscription = assign(:subscription, stub_model(Subscription,
      :email => "Email",
      :name => "Name",
      :paymill_id => "Paymill"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    rendered.should match(/Name/)
    rendered.should match(/Paymill/)
  end
end
