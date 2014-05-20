require 'spec_helper'

describe "work_hours/new" do
  before(:each) do
    assign(:work_hour, stub_model(WorkHour,
      :day_of_week => 1,
      :device_id => 1
    ).as_new_record)
  end

  it "renders new work_hour form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", work_hours_path, "post" do
      assert_select "input#work_hour_day_of_week[name=?]", "work_hour[day_of_week]"
      assert_select "input#work_hour_device_id[name=?]", "work_hour[device_id]"
    end
  end
end
