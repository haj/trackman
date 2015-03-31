require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe Car do
  
  describe "Cars#show" do 
    include_context "sign_in"
    include_context "sign_out"

    before (:each) do #revert to all if it doesn't work
      Time.zone = "GMT" 
      Traccar::Device.destroy_all
      @car = FactoryGirl.create(:car)
      @device = FactoryGirl.create(:device, car_id: @car.id)
      @traccar_device = Traccar::Device.create(name: @device.name, uniqueId: @device.emei)
      @traccar_device.users << Traccar::User.first
      @positions = @device.traccar_device.positions
      first_day = Time.zone.parse(Chronic.parse('4 dec 2014 8:00 am').to_s)
      5.times do |i| 
        @positions << FactoryGirl.create(:position, time: first_day, device_id: @traccar_device.id)
        # move time by 15 minutes
        first_day += 900 #900 seconds = 15 minutes
      end 
    end

    skip "should edit button" do 
    end

    it "should show vehicle name ..." do 
      visit car_path(@car) 
      expect(page).to have_content("About this vehicle")
    end

  end

end