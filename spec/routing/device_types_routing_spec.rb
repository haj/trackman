require "spec_helper"

describe DeviceTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/device_types").should route_to("device_types#index")
    end

    it "routes to #new" do
      get("/device_types/new").should route_to("device_types#new")
    end

    it "routes to #show" do
      get("/device_types/1").should route_to("device_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/device_types/1/edit").should route_to("device_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/device_types").should route_to("device_types#create")
    end

    it "routes to #update" do
      put("/device_types/1").should route_to("device_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/device_types/1").should route_to("device_types#destroy", :id => "1")
    end

  end
end
