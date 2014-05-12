require "spec_helper"

describe TeleprovidersController do
  describe "routing" do

    it "routes to #index" do
      get("/teleproviders").should route_to("teleproviders#index")
    end

    it "routes to #new" do
      get("/teleproviders/new").should route_to("teleproviders#new")
    end

    it "routes to #show" do
      get("/teleproviders/1").should route_to("teleproviders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/teleproviders/1/edit").should route_to("teleproviders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/teleproviders").should route_to("teleproviders#create")
    end

    it "routes to #update" do
      put("/teleproviders/1").should route_to("teleproviders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/teleproviders/1").should route_to("teleproviders#destroy", :id => "1")
    end

  end
end
