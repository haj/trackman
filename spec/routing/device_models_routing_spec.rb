require "spec_helper"

describe DeviceModelsController do
  describe "routing" do

    it "routes to #index" do
      get("/device_models").should route_to("device_models#index")
    end

    it "routes to #new" do
      get("/device_models/new").should route_to("device_models#new")
    end

    it "routes to #show" do
      get("/device_models/1").should route_to("device_models#show", :id => "1")
    end

    it "routes to #edit" do
      get("/device_models/1/edit").should route_to("device_models#edit", :id => "1")
    end

    it "routes to #create" do
      post("/device_models").should route_to("device_models#create")
    end

    it "routes to #update" do
      put("/device_models/1").should route_to("device_models#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/device_models/1").should route_to("device_models#destroy", :id => "1")
    end

  end
end
