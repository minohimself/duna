require "spec_helper"

describe ResearchesController do
  describe "routing" do

    it "routes to #index" do
      get("/researches").should route_to("researches#index")
    end

    it "routes to #new" do
      get("/researches/new").should route_to("researches#new")
    end

    it "routes to #show" do
      get("/researches/1").should route_to("researches#show", :id => "1")
    end

    it "routes to #edit" do
      get("/researches/1/edit").should route_to("researches#edit", :id => "1")
    end

    it "routes to #create" do
      post("/researches").should route_to("researches#create")
    end

    it "routes to #update" do
      put("/researches/1").should route_to("researches#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/researches/1").should route_to("researches#destroy", :id => "1")
    end

  end
end
