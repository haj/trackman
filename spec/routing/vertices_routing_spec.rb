require "spec_helper"

describe VerticesController do
  describe "routing" do

    it "routes to #index" do
      get("/vertices").should route_to("vertices#index")
    end

    it "routes to #new" do
      get("/vertices/new").should route_to("vertices#new")
    end

    it "routes to #show" do
      get("/vertices/1").should route_to("vertices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/vertices/1/edit").should route_to("vertices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/vertices").should route_to("vertices#create")
    end

    it "routes to #update" do
      put("/vertices/1").should route_to("vertices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/vertices/1").should route_to("vertices#destroy", :id => "1")
    end

  end
end
