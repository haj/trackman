require "spec_helper"

describe CarsController do
  describe "routing" do

    it "routes to #index" do
      get("/cars").should route_to("cars#index")
    end

    it "routes to #new" do
      get("/cars/new").should route_to("cars#new")
    end

    it "routes to #show" do
      get("/cars/1").should route_to("cars#show", :id => "1")
    end

    it "routes to #edit" do
      get("/cars/1/edit").should route_to("cars#edit", :id => "1")
    end

    it "routes to #create" do
      post("/cars").should route_to("cars#create")
    end

    it "routes to #update" do
      put("/cars/1").should route_to("cars#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/cars/1").should route_to("cars#destroy", :id => "1")
    end

  end
end
