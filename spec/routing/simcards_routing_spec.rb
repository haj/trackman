require "spec_helper"

describe SimcardsController do
  describe "routing" do

    it "routes to #index" do
      get("/simcards").should route_to("simcards#index")
    end

    it "routes to #new" do
      get("/simcards/new").should route_to("simcards#new")
    end

    it "routes to #show" do
      get("/simcards/1").should route_to("simcards#show", :id => "1")
    end

    it "routes to #edit" do
      get("/simcards/1/edit").should route_to("simcards#edit", :id => "1")
    end

    it "routes to #create" do
      post("/simcards").should route_to("simcards#create")
    end

    it "routes to #update" do
      put("/simcards/1").should route_to("simcards#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/simcards/1").should route_to("simcards#destroy", :id => "1")
    end

  end
end
