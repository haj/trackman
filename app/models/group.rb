# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

class Group < ActiveRecord::Base
	# init gem
	acts_as_tenant(:company)

	# association
	has_and_belongs_to_many :alarms
	has_many :alarm_groups
	has_many :cars

	# VALIDATION
	validates :name, presence: true

	# NESTED ATTR
	accepts_nested_attributes_for :alarms

	# INSTANCE METHOD
	def alarm_status(alarm)
		self.alarm_groups.where(alarm_id: alarm.id, group_id: self.id).first.status
	end

	def alarm_last_alert(alarm)
		self.alarm_groups.where(alarm_id: alarm.id, group_id: self.id).first.last_alert
	end	
end
