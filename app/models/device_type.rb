# == Schema Information
#
# Table name: device_types
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class DeviceType < ActiveRecord::Base
	has_many :devices
end
