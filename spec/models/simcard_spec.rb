# == Schema Information
#
# Table name: simcards
#
#  id               :integer          not null, primary key
#  telephone_number :string(255)
#  teleprovider_id  :integer
#  monthly_price    :float
#  device_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  company_id       :integer
#  deleted_at       :datetime
#  name             :string(255)
#

require 'spec_helper'

describe Simcard do
  pending "add some examples to (or delete) #{__FILE__}"
end
