require 'spec_helper'

describe "work_hours/show" do
  before(:each) do
    @work_hour = assign(:work_hour, stub_model(WorkHour,
      :day_of_week => 1,
      :device_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
