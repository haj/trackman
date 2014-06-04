# == Schema Information
#
# Table name: states
#
#  id               :integer          not null, primary key
#  data             :boolean          default(FALSE)
#  movement         :boolean          default(FALSE)
#  authorized_hours :boolean          default(FALSE)
#  speed_limit      :boolean          default(FALSE)
#  long_hours       :boolean          default(FALSE)
#  long_pause       :boolean          default(FALSE)
#  car_id           :integer
#  created_at       :datetime
#  updated_at       :datetime
#  speed            :float            default(0.0)
#

require 'spec_helper'

describe State do
  pending "add some examples to (or delete) #{__FILE__}"
end
