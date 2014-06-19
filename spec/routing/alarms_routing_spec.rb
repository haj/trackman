require "spec_helper"

describe AlarmsController do
  describe "routing" do

    it "routes to #index" do
      get("/alarms").should route_to("alarms#index")
    end

    it "routes to #new" do
      get("/alarms/new").should route_to("alarms#new")
    end

    it "routes to #show" do
      get("/alarms/1").should route_to("alarms#show", :id => "1")
    end

    it "routes to #edit" do
      get("/alarms/1/edit").should route_to("alarms#edit", :id => "1")
    end

    it "routes to #create" do
      post("/alarms").should route_to("alarms#create")
    end

    it "routes to #update" do
      put("/alarms/1").should route_to("alarms#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/alarms/1").should route_to("alarms#destroy", :id => "1")
    end

  end
end
