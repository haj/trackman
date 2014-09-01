require 'spec_helper'

describe "work_schedule_groups/edit" do
  before(:each) do
    @work_schedule_group = assign(:work_schedule_group, stub_model(WorkScheduleGroup,
      :company_id => 1,
      :work_schedule_id => 1
    ))
  end

  it "renders the edit work_schedule_group form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", work_schedule_group_path(@work_schedule_group), "post" do
      assert_select "input#work_schedule_group_company_id[name=?]", "work_schedule_group[company_id]"
      assert_select "input#work_schedule_group_work_schedule_id[name=?]", "work_schedule_group[work_schedule_id]"
    end
  end
end
