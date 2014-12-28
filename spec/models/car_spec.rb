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
			@car = FactoryGirl.create(:car)
		    @device = FactoryGirl.create(:device, car_id: @car.id)
		    @traccar_device = Traccar::Device.create(name: @device.name, uniqueId: @device.emei)
		    @traccar_device.users << Traccar::User.first
		    @positions = @device.traccar_device.positions

		    first_day = Time.zone.parse(Chronic.parse('4 dec 8:00 am').to_s)
		    
		    5.times do |i| 
		      @positions << Traccar::Position.create( 
		        latitude: 48.856614, 
		        longitude: 2.352222, 
		        speed: 60.0, 
		        time: first_day, 
		        created_at: first_day, 
		        valid: true, 
		        device_id: @traccar_device.id)
		      # move time by 15 minutes
		      first_day += 900 #900 seconds = 15 minutes
		    end 
		end

		it "Should return at least one position" do 
		    dates = Hash.new
		    dates[:start_date] = "4/12/2014"
		    dates[:start_time] = "08:15"
		    dates[:end_date] = "4/12/2014"
		    dates[:end_time] = "09:15"
		    result = @car.positions_with_dates(dates)
		    expect(result.count).to_not eq(0)
		end

		it "Should return at no positions" do 
		    dates = Hash.new
		    dates[:start_date] = "4/12/2014"
		    dates[:start_time] = "07:15"
		    dates[:end_date] = "4/12/2014"
		    dates[:end_time] = "07:55"
		    result = @car.positions_with_dates(dates)
		    expect(result.count).to eq(0)
		end


	end


end
