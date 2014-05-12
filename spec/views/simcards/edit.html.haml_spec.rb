require 'spec_helper'

describe "simcards/edit" do
  before(:each) do
    @simcard = assign(:simcard, stub_model(Simcard,
      :telephone_number => "MyString",
      :teleprovider_id => 1,
      :monthly_price => 1.5,
      :device_id => 1
    ))
  end

  it "renders the edit simcard form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", simcard_path(@simcard), "post" do
      assert_select "input#simcard_telephone_number[name=?]", "simcard[telephone_number]"
      assert_select "input#simcard_teleprovider_id[name=?]", "simcard[teleprovider_id]"
      assert_select "input#simcard_monthly_price[name=?]", "simcard[monthly_price]"
      assert_select "input#simcard_device_id[name=?]", "simcard[device_id]"
    end
  end
end
