require "spec_helper"

describe DeviceManufacturersController do
  describe "routing" do

    it "routes to #index" do
      get("/device_manufacturers").should route_to("device_manufacturers#index")
    end

    it "routes to #new" do
      get("/device_manufacturers/new").should route_to("device_manufacturers#new")
    end

    it "routes to #show" do
      get("/device_manufacturers/1").should route_to("device_manufacturers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/device_manufacturers/1/edit").should route_to("device_manufacturers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/device_manufacturers").should route_to("device_manufacturers#create")
    end

    it "routes to #update" do
      put("/device_manufacturers/1").should route_to("device_manufacturers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/device_manufacturers/1").should route_to("device_manufacturers#destroy", :id => "1")
    end

  end
end
