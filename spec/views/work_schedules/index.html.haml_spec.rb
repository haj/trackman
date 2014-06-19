require 'spec_helper'

describe "work_schedules/index" do
  before(:each) do
    assign(:work_schedules, [
      stub_model(WorkSchedule,
        :car_id => 1,
        :name => "Name"
      ),
      stub_model(WorkSchedule,
        :car_id => 1,
        :name => "Name"
      )
    ])
  end

  it "renders a list of work_schedules" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
