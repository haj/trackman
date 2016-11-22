# == Schema Information
#
# Table name: device_models
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  device_manufacturer_id :integer
#  protocol               :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#

class DeviceModel < ActiveRecord::Base
  # ASSOCIATION
  has_many :devices
  belongs_to :device_manufacturer

  # VALIDATION
  validates :name, :device_manufacturer_id, :protocol, presence: true

  # SCOPE
  scope :by_device_manufacturer, -> device_manufacturer_id { where(:device_manufacturer_id => device_manufacturer_id) }
end
