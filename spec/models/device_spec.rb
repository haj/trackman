# == Schema Information
#
# Table name: devices
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  emei            :string(255)
#  cost_price      :float
#  created_at      :datetime
#  updated_at      :datetime
#  device_model_id :integer
#  device_type_id  :integer
#  car_id          :integer
#  company_id      :integer
#  movement        :boolean
#  last_checked    :datetime
#  deleted_at      :datetime
#

require 'spec_helper'

describe Device do
  skip "add some examples to (or delete) #{__FILE__}"
end
