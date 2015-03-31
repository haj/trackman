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
  			new_work_hour = WorkHour.create(day_of_week: 4, starts_at: Time.zone.parse("7 am").utc.to_s(:db), ends_at: Time.zone.parse("7 pm").utc.to_s(:db) , work_schedule_id: @work_schedule.id)
  		end
    end

  	it "should return a new record of type WorkSchedule" do 
  		cloned_work_schedule = @work_schedule.create_clone
  		expect(cloned_work_schedule.class).to eq WorkSchedule
  	end

  	it "should not return false" do 
  		cloned_work_schedule = @work_schedule.create_clone
  		expect(cloned_work_schedule).not_to eq false
  	end

  	it "should have associations" do 
  		cloned_work_schedule = @work_schedule.create_clone
  		expect(cloned_work_schedule.work_hours.count).to eq 4
  	end

    it "should have correct starting hour and ending hour" do 
      Time.use_zone('Bangkok') do
        cloned_work_schedule = @work_schedule.create_clone
        start_time = cloned_work_schedule.work_hours.first.starts_at.to_s
        end_time = cloned_work_schedule.work_hours.first.ends_at.to_s
        
        expect(start_time).to eq "06:00:00"
        expect(end_time).to eq "18:00:00"
      end  

      Time.use_zone('Fiji') do
        cloned_work_schedule = @work_schedule.create_clone
        start_time = cloned_work_schedule.work_hours.first.starts_at.to_s
        end_time = cloned_work_schedule.work_hours.first.ends_at.to_s
        
        expect(start_time).to eq "06:00:00"
        expect(end_time).to eq "18:00:00"
      end
    end

  end

end
