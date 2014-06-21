# == Schema Information
#
# Table name: rules
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  method_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Rule do
  	it "add some examples to (or delete) #{__FILE__}"

  	describe "alarm when vehicle not sending data for more than X minutes" do 
  		it "should trigger alarm when no data received" do 

  		end
	end

  	describe "alarm when vehicle stopped for more than X minutes" do 

	end

	describe "alarm when vehicle moving for more than X minutes" do 

	end

	describe "alarm when vehicle started moving" do 
	end

	describe "alarm when vehicle moving with engine off" do 
		it "shouldn't trigger alarm when no data received from vehicle" do

		end

		it "shouldn't trigger alarm when vehicle not moving" do 

		end

		it "should trigger alarm when " do

		end
	end

	describe "alarm when vehicle going faster than X km/h" do 

		before(:each) do
      		# setup rules
			# setup alarm with params
    	end

		it "shouldn't trigger alarm when no data received from vehicle" do
		end

		it "shouldn't trigger alarm when vehicle not moving" do 

		end

		it "should trigger alarm when speed > X km/h" do 
			# setup few positions where car is moving + speed > X 
			

		end
	end

	describe "alarm when vehicle going slower than X km/h" do 
		it "shouldn't trigger alarm when no data received from vehicle" do
		end

		it "shouldn't trigger alarm when vehicle not moving" do 
		end

		it "should trigger alarm when speed < X km/h" do 
		end
	end

	describe "alarm when vehicle used outside work hours" do 
		it "should return when vehicle used outside work hours" do 
			
		end
	end	

	describe "alarm when vehicle got into an area" do 
	end	

	describe "alarm when vehicle got out of an area" do 
	end	

	describe "alarm when vehicle got out of the planned route" do 
	end	





end
