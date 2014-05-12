require "spec_helper"

describe CarManufacturersController do
  describe "routing" do

    it "routes to #index" do
      get("/car_manufacturers").should route_to("car_manufacturers#index")
    end

    it "routes to #new" do
      get("/car_manufacturers/new").should route_to("car_manufacturers#new")
    end

    it "routes to #show" do
      get("/car_manufacturers/1").should route_to("car_manufacturers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/car_manufacturers/1/edit").should route_to("car_manufacturers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/car_manufacturers").should route_to("car_manufacturers#create")
    end

    it "routes to #update" do
      put("/car_manufacturers/1").should route_to("car_manufacturers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/car_manufacturers/1").should route_to("car_manufacturers#destroy", :id => "1")
    end

  end
end
