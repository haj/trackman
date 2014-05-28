require "spec_helper"

describe ParametersController do
  describe "routing" do

    it "routes to #index" do
      get("/parameters").should route_to("parameters#index")
    end

    it "routes to #new" do
      get("/parameters/new").should route_to("parameters#new")
    end

    it "routes to #show" do
      get("/parameters/1").should route_to("parameters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/parameters/1/edit").should route_to("parameters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/parameters").should route_to("parameters#create")
    end

    it "routes to #update" do
      put("/parameters/1").should route_to("parameters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/parameters/1").should route_to("parameters#destroy", :id => "1")
    end

  end
end
