require "spec_helper"

describe PlanTypesController do
  describe "routing" do

    it "routes to #index" do
      get("/plan_types").should route_to("plan_types#index")
    end

    it "routes to #new" do
      get("/plan_types/new").should route_to("plan_types#new")
    end

    it "routes to #show" do
      get("/plan_types/1").should route_to("plan_types#show", :id => "1")
    end

    it "routes to #edit" do
      get("/plan_types/1/edit").should route_to("plan_types#edit", :id => "1")
    end

    it "routes to #create" do
      post("/plan_types").should route_to("plan_types#create")
    end

    it "routes to #update" do
      put("/plan_types/1").should route_to("plan_types#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/plan_types/1").should route_to("plan_types#destroy", :id => "1")
    end

  end
end
