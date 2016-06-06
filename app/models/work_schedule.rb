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
