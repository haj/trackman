require 'spec_helper'

describe "work_schedule_groups/show" do
  before(:each) do
    @work_schedule_group = assign(:work_schedule_group, stub_model(WorkScheduleGroup,
      :company_id => 1,
      :work_schedule_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
  end
end
