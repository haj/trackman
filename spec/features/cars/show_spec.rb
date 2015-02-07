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
        @positions << FactoryGirl.create(:position, time: first_day, created_at: first_day, device_id: @traccar_device.id)
        # move time by 15 minutes
        first_day += 900 #900 seconds = 15 minutes
      end 
    end

    it "Should show the exact positions between two dates (and previous or later dates)" do
      visit car_path(@car) 
      fill_in "dates_start_date", with: "4/12/2014"
      fill_in "dates_start_time", with: "08:15"
      fill_in "dates_end_date", with: "4/12/2014"
      fill_in "dates_end_time", with: "09:00"
      click_button "Apply" 
      expect(page).to have_content("8:15")
      expect(page).to_not have_content("8:00")
    end

    it "Should show some positions by default" do
      visit car_path(@car) 
      expect(page).to_not have_content("No positions available for this period") 
      expect(page).to have_content("Address")
    end

    it "Should list positions when user select period where there was positions" do
      visit car_path(@car) 
      fill_in "dates_start_date", with: "4/12/2014"
      fill_in "dates_start_time", with: "08:15"
      fill_in "dates_end_date", with: "4/12/2014"
      fill_in "dates_end_time", with: "09:00"
      click_button "Apply"
      expect(page).to_not have_content("No positions available for this period")
    end

    it "Shouldn't list positions when user select period where there was positions" do
      visit car_path(@car) 
      # select first day positions with filter        
      fill_in "dates_start_date", with: "4/12/2014"
      fill_in "dates_start_time", with: "06:00"
      fill_in "dates_end_date", with: "4/12/2014"
      fill_in "dates_end_time", with: "07:00"
      click_button "Apply"
      expect(page).to have_content("No positions available for this period")  
    end

  end

end