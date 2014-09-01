require "spec_helper"

describe WorkScheduleGroupsController do
  describe "routing" do

    it "routes to #index" do
      get("/work_schedule_groups").should route_to("work_schedule_groups#index")
    end

    it "routes to #new" do
      get("/work_schedule_groups/new").should route_to("work_schedule_groups#new")
    end

    it "routes to #show" do
      get("/work_schedule_groups/1").should route_to("work_schedule_groups#show", :id => "1")
    end

    it "routes to #edit" do
      get("/work_schedule_groups/1/edit").should route_to("work_schedule_groups#edit", :id => "1")
    end

    it "routes to #create" do
      post("/work_schedule_groups").should route_to("work_schedule_groups#create")
    end

    it "routes to #update" do
      put("/work_schedule_groups/1").should route_to("work_schedule_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/work_schedule_groups/1").should route_to("work_schedule_groups#destroy", :id => "1")
    end

  end
end
