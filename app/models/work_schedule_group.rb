# == Schema Information
#
# Table name: work_schedule_groups
#
#  id               :integer          not null, primary key
#  company_id       :integer
#  work_schedule_id :integer
#  created_at       :datetime
#  updated_at       :datetime
#  name             :string(255)
#

class WorkScheduleGroup < ActiveRecord::Base
	belongs_to :work_schedule

	validates :name, :work_schedule_id, presence: true
end
