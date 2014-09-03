class AlarmNotification < ActiveRecord::Base
	belongs_to :alarm
	belongs_to :car 

	acts_as_tenant(:company)
end
