require 'spec_helper'

describe "work_schedules/show" do
  before(:each) do
    @work_schedule = assign(:work_schedule, stub_model(WorkSchedule,
      :car_id => 1,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/Name/)
  end
end
