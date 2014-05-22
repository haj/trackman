require 'spec_helper'

describe "work_hours/edit" do
  before(:each) do
    @work_hour = assign(:work_hour, stub_model(WorkHour,
      :day_of_week => 1,
      :device_id => 1
    ))
  end

  it "renders the edit work_hour form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", work_hour_path(@work_hour), "post" do
      assert_select "input#work_hour_day_of_week[name=?]", "work_hour[day_of_week]"
      assert_select "input#work_hour_device_id[name=?]", "work_hour[device_id]"
    end
  end
end
