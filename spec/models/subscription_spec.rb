# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer          not null, primary key
#  email      :string(255)
#  name       :string(255)
#  paymill_id :string(255)
#  created_at :datetime
#  updated_at :datetime
#  plan_id    :integer
#  company_id :integer
#  active     :boolean
#

require 'spec_helper'

describe Subscription do
  skip "add some examples to (or delete) #{__FILE__}"
end
