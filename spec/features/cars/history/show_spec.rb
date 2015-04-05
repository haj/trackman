require "spec_helper"
include Warden::Test::Helpers
Warden.test_mode!

describe Car do
  
  describe "Cars#show" do 
    include_context "sign_in"
    include_context "sign_out"

    before (:each) do #revert to all if it doesn't work
      Time.use_zone('UTC') do 
        Traccar::Device.destroy_all
        @car = FactoryGirl.create(:car)
        @device = FactoryGirl.create(:device, car_id: @car.id)

        # traccar device 
        @traccar_device = Traccar::Device.create(name: @device.name, uniqueId: @device.emei)
        @traccar_device.users << Traccar::User.first
        @positions = @device.traccar_device.positions

        # positions from 8:00 to 9:00 UTC
        first_day = Time.zone.parse(Chronic.parse('4 dec 2014 8:00 am').to_s)
        5.times do |i| 
          @positions << FactoryGirl.create(:position, time: first_day, device_id: @traccar_device.id)
          # move time by 15 minutes
          first_day += 900 #900 seconds = 15 minutes
        end 
      end
    end

    it "Should show the exact positions between two dates (and previous or later dates)" do
      visit positions_car_path(@car) 
      fill_in "dates_start_date", with: "4/12/2014"
      fill_in "dates_start_time", with: "09:15" #08:15 UTC
      fill_in "dates_end_date", with: "4/12/2014"
      fill_in "dates_end_time", with: "10:00" #09:00 UTC
      click_button "Apply" 
      expect(page).to have_content("9:15")
      expect(page).to_not have_content("8:00")
    end

    it "Should show 30 positions by default" do
      visit positions_car_path(@car) 
      expect(page).to_not have_content("No positions available for this period") 
      expect(page).to have_content("Address")
      expect(page).to have_content("(5)")
    end

    it "Should list 1 position" do
      visit positions_car_path(@car)
      fill_in "dates_start_date", with: "4/12/2014"
      fill_in "dates_start_time", with: "8:00"
      fill_in "dates_end_date", with: "4/12/2014"
      fill_in "dates_end_time", with: "9:00"
      click_button "Apply"
      expect(page).to_not have_content("No positions available for this period")
      expect(page).to have_content("(1)")
    end

    it "Should list few positions" do
      visit positions_car_path(@car) 
      fill_in "dates_start_date", with: "4/12/2014"
      fill_in "dates_start_time", with: "08:15"
      fill_in "dates_end_date", with: "4/12/2014"
      fill_in "dates_end_time", with: "09:00"
      click_button "Apply"
      expect(page).to_not have_content("No positions available for this period")
      expect(page).to have_content("48.85661")
    end

    it "Should list NO positions" do
      visit positions_car_path(@car) 
      # select first day positions with filter        
      fill_in "dates_start_date", with: "4/12/2014"
      fill_in "dates_start_time", with: "11:00"
      fill_in "dates_end_date", with: "4/12/2014"
      fill_in "dates_end_time", with: "12:00"
      click_button "Apply"
      expect(page).to have_content("No positions available for this period")
    end



  end

end