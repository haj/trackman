require "spec_helper"

describe WorkSchedulesController do
  describe "routing" do

    it "routes to #index" do
      get("/work_schedules").should route_to("work_schedules#index")
    end

    it "routes to #new" do
      get("/work_schedules/new").should route_to("work_schedules#new")
    end

    it "routes to #show" do
      get("/work_schedules/1").should route_to("work_schedules#show", :id => "1")
    end

    it "routes to #edit" do
      get("/work_schedules/1/edit").should route_to("work_schedules#edit", :id => "1")
    end

    it "routes to #create" do
      post("/work_schedules").should route_to("work_schedules#create")
    end

    it "routes to #update" do
      put("/work_schedules/1").should route_to("work_schedules#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/work_schedules/1").should route_to("work_schedules#destroy", :id => "1")
    end

  end
end
