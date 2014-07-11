require "spec_helper"

describe FeaturesController do
  describe "routing" do

    it "routes to #index" do
      get("/features").should route_to("features#index")
    end

    it "routes to #new" do
      get("/features/new").should route_to("features#new")
    end

    it "routes to #show" do
      get("/features/1").should route_to("features#show", :id => "1")
    end

    it "routes to #edit" do
      get("/features/1/edit").should route_to("features#edit", :id => "1")
    end

    it "routes to #create" do
      post("/features").should route_to("features#create")
    end

    it "routes to #update" do
      put("/features/1").should route_to("features#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/features/1").should route_to("features#destroy", :id => "1")
    end

  end
end
