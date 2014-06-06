# == Schema Information
#
# Table name: states
#
#  id         :integer          not null, primary key
#  no_data    :boolean          default(FALSE)
#  moving     :boolean          default(FALSE)
#  car_id     :integer
#  created_at :datetime
#  updated_at :datetime
#  speed      :float            default(0.0)
#  driver_id  :integer
#  device_id  :integer
#

require 'spec_helper'

describe State do
  pending "add some examples to (or delete) #{__FILE__}"
end
