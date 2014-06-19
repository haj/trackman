require 'spec_helper'

describe "work_schedules/new" do
  before(:each) do
    assign(:work_schedule, stub_model(WorkSchedule,
      :car_id => 1,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new work_schedule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", work_schedules_path, "post" do
      assert_select "input#work_schedule_car_id[name=?]", "work_schedule[car_id]"
      assert_select "input#work_schedule_name[name=?]", "work_schedule[name]"
    end
  end
end
