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

class WorkSchedule < ActiveRecord::Base
  has_many :cars
  has_many :work_hours, :dependent => :destroy
  has_many :work_schedule_group 

  validates :name, presence: true

  acts_as_paranoid

  acts_as_tenant(:company)

  attr_accessor :shifts

  after_save :create_work_hours

  def create_work_hours
    self.shifts.values.each do |shift| 
      start_time = shift['start'].to_time
      end_time   = shift['end'].to_time
      wday_index = shift['wday']
      
      if end_time.hour == 0 && end_time.min == 0
        new_work_hour = WorkHour.create(starts_at: start_time.to_s(:db) , ends_at: Time.parse("23:59").to_s(:db) , day_of_week: wday_index)
      else
        new_work_hour = WorkHour.create(starts_at: start_time.to_s(:db) , ends_at: end_time.to_s(:db) , day_of_week: wday_index)
      end

      self.work_hours << new_work_hour
    end
  end

  def create_clone
    work_schedule = WorkSchedule.new
    work_schedule.name = self.name
    
    if work_schedule.save
      Time.use_zone('UTC') do
        self.work_hours.each do |work_hour|
          WorkHour.create do |new_work_hour|
            new_work_hour.day_of_week = work_hour.day_of_week
            new_work_hour.starts_at = Time.zone.parse(work_hour.starts_at.to_s).to_s(:db)
            new_work_hour.ends_at = Time.zone.parse(work_hour.ends_at.to_s).to_s(:db)
            new_work_hour.work_schedule_id = work_schedule.id
          end
        end 
      end

      return work_schedule
    else
      return false
    end
  end
end
