require 'spec_helper'

describe "work_schedule_groups/new" do
  before(:each) do
    assign(:work_schedule_group, stub_model(WorkScheduleGroup,
      :company_id => 1,
      :work_schedule_id => 1
    ).as_new_record)
  end

  it "renders new work_schedule_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", work_schedule_groups_path, "post" do
      assert_select "input#work_schedule_group_company_id[name=?]", "work_schedule_group[company_id]"
      assert_select "input#work_schedule_group_work_schedule_id[name=?]", "work_schedule_group[work_schedule_id]"
    end
  end
end
