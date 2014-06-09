require 'spec_helper'

describe "vertices/edit" do
  before(:each) do
    @vertex = assign(:vertex, stub_model(Vertex,
      :latitude => 1.5,
      :longitude => 1.5,
      :region_id => 1
    ))
  end

  it "renders the edit vertex form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", vertex_path(@vertex), "post" do
      assert_select "input#vertex_latitude[name=?]", "vertex[latitude]"
      assert_select "input#vertex_longitude[name=?]", "vertex[longitude]"
      assert_select "input#vertex_region_id[name=?]", "vertex[region_id]"
    end
  end
end
