# == Schema Information
#
# Table name: work_schedules
#
#  id         :integer          not null, primary key
#  car_id     :integer
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe WorkSchedule do
  pending "add some examples to (or delete) #{__FILE__}"


  describe ".clone_record" do 

  	before (:each) do
      	@work_schedule = WorkSchedule.create(name: "some_random_work_schedule")
		4.times do 
			new_work_hour = WorkHour.create(day_of_week: 4, starts_at: Time.now, ends_at: Time.now , work_schedule_id: @work_schedule.id)
			@work_schedule.work_hours << new_work_hour
		end
    end

  	it "should return a new record of type WorkSchedule" do 
  		# create a work_schedule and attach to it few work hours
  		
  		cloned_work_schedule = @work_schedule.create_clone
  		cloned_work_schedule.class.should == WorkSchedule

  		 
  	end

  	it "should not return false" do 
  		cloned_work_schedule = @work_schedule.create_clone
  		cloned_work_schedule.should_not == false
  	end

  	it "should have associations" do 
  		cloned_work_schedule = @work_schedule.create_clone
  		cloned_work_schedule.work_hours.count.should == 4
  	end

  end

end
