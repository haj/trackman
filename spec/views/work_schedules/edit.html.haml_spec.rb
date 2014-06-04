require 'spec_helper'

describe "work_schedules/edit" do
  before(:each) do
    @work_schedule = assign(:work_schedule, stub_model(WorkSchedule,
      :car_id => 1,
      :name => "MyString"
    ))
  end

  it "renders the edit work_schedule form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", work_schedule_path(@work_schedule), "post" do
      assert_select "input#work_schedule_car_id[name=?]", "work_schedule[car_id]"
      assert_select "input#work_schedule_name[name=?]", "work_schedule[name]"
    end
  end
end
