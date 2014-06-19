require "spec_helper"

describe WorkHoursController do
  describe "routing" do

    it "routes to #index" do
      get("/work_hours").should route_to("work_hours#index")
    end

    it "routes to #new" do
      get("/work_hours/new").should route_to("work_hours#new")
    end

    it "routes to #show" do
      get("/work_hours/1").should route_to("work_hours#show", :id => "1")
    end

    it "routes to #edit" do
      get("/work_hours/1/edit").should route_to("work_hours#edit", :id => "1")
    end

    it "routes to #create" do
      post("/work_hours").should route_to("work_hours#create")
    end

    it "routes to #update" do
      put("/work_hours/1").should route_to("work_hours#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/work_hours/1").should route_to("work_hours#destroy", :id => "1")
    end

  end
end
