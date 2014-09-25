# == Schema Information
#
# Table name: plans
#
#  id           :integer          not null, primary key
#  plan_type_id :integer
#  interval     :string(255)
#  currency     :string(255)
#  price        :float
#  paymill_id   :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Plan do
  pending "add some examples to (or delete) #{__FILE__}"
end
