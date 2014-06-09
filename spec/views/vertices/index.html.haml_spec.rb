require 'spec_helper'

describe "vertices/index" do
  before(:each) do
    assign(:vertices, [
      stub_model(Vertex,
        :latitude => 1.5,
        :longitude => 1.5,
        :region_id => 1
      ),
      stub_model(Vertex,
        :latitude => 1.5,
        :longitude => 1.5,
        :region_id => 1
      )
    ])
  end

  it "renders a list of vertices" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
