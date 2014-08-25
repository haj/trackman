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

	describe "Alarms" do
		it "should trigger alarm only one time" do 
  			# set up car
  		end 
	end
	

	
	
end
