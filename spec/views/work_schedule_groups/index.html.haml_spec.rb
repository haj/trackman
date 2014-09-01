require 'spec_helper'

describe "work_schedule_groups/index" do
  before(:each) do
    assign(:work_schedule_groups, [
      stub_model(WorkScheduleGroup,
        :company_id => 1,
        :work_schedule_id => 2
      ),
      stub_model(WorkScheduleGroup,
        :company_id => 1,
        :work_schedule_id => 2
      )
    ])
  end

  it "renders a list of work_schedule_groups" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
