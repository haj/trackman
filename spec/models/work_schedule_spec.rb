# == Schema Information
#
# Table name: work_schedules
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  deleted_at :datetime
#

require 'spec_helper'

describe WorkSchedule do

  describe ".clone_record" do 

  	before (:each) do
      Time.zone = "Casablanca"
      @work_schedule = WorkSchedule.create(name: "some_random_work_schedule")
  		4.times do 
  			new_work_hour = WorkHour.create(day_of_week: 4, starts_at: Time.zone.parse("7 am").to_s(:db), ends_at: Time.zone.parse("7 pm").to_s(:db) , work_schedule_id: @work_schedule.id)
  		end
    end

  	it "should return a new record of type WorkSchedule" do 
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

    it "should have correct starting hour and ending hour" do 
      Time.use_zone('Hawaii') do
        cloned_work_schedule = @work_schedule.create_clone
        cloned_work_schedule.work_hours.first.starts_at.to_s.should_not  == "07:00:00"
        cloned_work_schedule.work_hours.first.ends_at.to_s.should_not  == "07:00:00"
      end  
    end

  end

end
