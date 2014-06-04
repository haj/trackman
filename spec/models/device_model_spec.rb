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

require 'spec_helper'

describe DeviceModel do
  pending "add some examples to (or delete) #{__FILE__}"
end
