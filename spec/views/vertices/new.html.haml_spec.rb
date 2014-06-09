require 'spec_helper'

describe "vertices/new" do
  before(:each) do
    assign(:vertex, stub_model(Vertex,
      :latitude => 1.5,
      :longitude => 1.5,
      :region_id => 1
    ).as_new_record)
  end

  it "renders new vertex form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", vertices_path, "post" do
      assert_select "input#vertex_latitude[name=?]", "vertex[latitude]"
      assert_select "input#vertex_longitude[name=?]", "vertex[longitude]"
      assert_select "input#vertex_region_id[name=?]", "vertex[region_id]"
    end
  end
end
