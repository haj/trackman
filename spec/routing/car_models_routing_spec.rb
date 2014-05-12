require "spec_helper"

describe CarModelsController do
  describe "routing" do

    it "routes to #index" do
      get("/car_models").should route_to("car_models#index")
    end

    it "routes to #new" do
      get("/car_models/new").should route_to("car_models#new")
    end

    it "routes to #show" do
      get("/car_models/1").should route_to("car_models#show", :id => "1")
    end

    it "routes to #edit" do
      get("/car_models/1/edit").should route_to("car_models#edit", :id => "1")
    end

    it "routes to #create" do
      post("/car_models").should route_to("car_models#create")
    end

    it "routes to #update" do
      put("/car_models/1").should route_to("car_models#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/car_models/1").should route_to("car_models#destroy", :id => "1")
    end

  end
end
