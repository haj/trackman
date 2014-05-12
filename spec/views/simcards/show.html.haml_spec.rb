require 'spec_helper'

describe "simcards/show" do
  before(:each) do
    @simcard = assign(:simcard, stub_model(Simcard,
      :telephone_number => "Telephone Number",
      :teleprovider_id => 1,
      :monthly_price => 1.5,
      :device_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Telephone Number/)
    rendered.should match(/1/)
    rendered.should match(/1.5/)
    rendered.should match(/2/)
  end
end
