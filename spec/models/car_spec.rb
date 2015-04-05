# == Schema Information
#
# Table name: cars
#
#  id               :integer          not null, primary key
#  mileage          :float
#  numberplate      :string(255)
#  car_model_id     :integer
#  car_type_id      :integer
#  registration_no  :string(255)
#  year             :integer
#  color            :string(255)
#  group_id         :integer
#  created_at       :datetime
#  updated_at       :datetime
#  company_id       :integer
#  work_schedule_id :integer
#  name             :string(255)
#  deleted_at       :datetime
#

	# == Schema Information
	#
	# Table name: cars
	#
	#  id              :integer          not null, primary key
	#  mileage         :float
	#  numberplate     :string(255)
	#  car_model_id    :integer
	#  car_type_id     :integer
	#  registration_no :string(255)
	#  year            :integer
	#  color           :string(255)
	#  group_id        :integer
	#  created_at      :datetime
	#  updated_at      :datetime
	#  company_id      :integer
	#

require 'spec_helper'

describe Car do

	describe ".positions_with_dates" do 

		before(:each) do
			Traccar::Position.destroy_all
			@car = FactoryGirl.create(:car)
		    @device = FactoryGirl.create(:device, car_id: @car.id)
		    @traccar_device = Traccar::Device.create(name: @device.name, uniqueId: @device.emei)
		    @traccar_device.users << Traccar::User.first
		    @positions = @device.traccar_device.positions
		    start_date = Time.zone.parse(Chronic.parse('4 dec 2014 8:00 am').to_s).utc		    
		    # positions from 8:00 to 9:00 UTC
		    5.times do |i| 
		      @positions << Traccar::Position.create( 
		        latitude: 48.856614, 
		        longitude: 2.352222, 
		        speed: 60.0, 
		        time: start_date.to_s(:db), 
		        valid: true, 
		        device_id: @traccar_device.id)
		      # move time by 15 minutes
		      start_date += 900 #900 seconds = 15 minutes
		    end 
		end

		it "Should return 1 position", focus: true do 
		    dates = Hash.new
		    dates[:start_date] = "4/12/2014"
		    dates[:start_time] = "09:00" #08:00 UTC
		    dates[:end_date] = "4/12/2014"
		    dates[:end_time] = "09:14" #08:14 UTC
		    result = @car.positions_with_dates(dates, "Copenhagen")
		    expect(result.count).to eq(1)
		end

		it "Should return 1 position" do 
		    dates = Hash.new
		    dates[:start_date] = "4/12/2014"
		    dates[:start_time] = "08:00" #07:00 UTC
		    dates[:end_date] = "4/12/2014"
		    dates[:end_time] = "09:00" #08:00 UTC
		    result = @car.positions_with_dates(dates, "Copenhagen")
		    expect(result.count).to eq(1)
		end

		it "Should return no positions" do 
		    dates = Hash.new
		    dates[:start_date] = "4/12/2014"
		    dates[:start_time] = "07:15"
		    dates[:end_date] = "4/12/2014"
		    dates[:end_time] = "07:55"
		    result = @car.positions_with_dates(dates, "Copenhagen")
		    expect(result.count).to eq(0)
		end

	end


end
