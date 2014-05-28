require 'spec_helper'

describe "alarms/show" do
  before(:each) do
    @alarm = assign(:alarm, stub_model(Alarm,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
