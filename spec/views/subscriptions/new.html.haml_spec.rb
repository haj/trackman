require 'spec_helper'

describe "subscriptions/new" do
  before(:each) do
    assign(:subscription, stub_model(Subscription,
      :email => "MyString",
      :name => "MyString",
      :paymill_id => "MyString"
    ).as_new_record)
  end

  it "renders new subscription form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", subscriptions_path, "post" do
      assert_select "input#subscription_email[name=?]", "subscription[email]"
      assert_select "input#subscription_name[name=?]", "subscription[name]"
      assert_select "input#subscription_paymill_id[name=?]", "subscription[paymill_id]"
    end
  end
end
