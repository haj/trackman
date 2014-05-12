require "spec_helper"

describe CarTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/car_types").should route_to("car_types#index")
    end

    it "routes to #new" do
      get("/car_types/new").should route_to("car_types#new")
    end

    it "routes to #show" do
      get("/car_types/1").should route_to("car_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/car_types/1/edit").should route_to("car_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/car_types").should route_to("car_types#create")
    end

    it "routes to #update" do
      put("/car_types/1").should route_to("car_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/car_types/1").should route_to("car_types#destroy", :id => "1")
    end

  end
end
