require 'spec_helper'

describe "vertices/show" do
  before(:each) do
    @vertex = assign(:vertex, stub_model(Vertex,
      :latitude => 1.5,
      :longitude => 1.5,
      :region_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
    rendered.should match(/1/)
  end
end
