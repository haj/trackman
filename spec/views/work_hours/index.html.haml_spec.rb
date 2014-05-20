require 'spec_helper'

describe "work_hours/index" do
  before(:each) do
    assign(:work_hours, [
      stub_model(WorkHour,
        :day_of_week => 1,
        :device_id => 2
      ),
      stub_model(WorkHour,
        :day_of_week => 1,
        :device_id => 2
      )
    ])
  end

  it "renders a list of work_hours" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
