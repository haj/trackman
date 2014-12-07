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

	
	
end
