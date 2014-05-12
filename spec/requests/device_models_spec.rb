require 'spec_helper'

describe "DeviceModels" do
  describe "GET /device_models" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get device_models_path
      response.status.should be(200)
    end
  end
end
