# == Schema Information
#
# Table name: locations
#
#  id               :integer          not null, primary key
#  address          :string(255)
#  position_id      :integer
#  created_at       :datetime
#  updated_at       :datetime
#  city             :string(255)
#  country          :string(255)
#  state            :string(255)
#  device_id        :integer
#  time             :datetime
#  speed            :float(24)
#  valid_position   :boolean
#  driving_duration :string(255)
#  parking_duration :string(255)
#  longitude        :float(24)
#  latitude         :float(24)
#  status           :string(255)
#  ignite_step      :integer
#  ignite           :boolean
#  avg              :float(24)
#  max              :float(24)
#  min              :float(24)
#  trip_step        :integer
#  step_distance    :float(24)
#

require 'spec_helper'

describe Traccar::Location do
  skip "add some examples to (or delete) #{__FILE__}"
end
