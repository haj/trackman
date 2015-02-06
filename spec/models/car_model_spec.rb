# == Schema Information
#
# Table name: car_models
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  car_manufacturer_id :integer
#  created_at          :datetime
#  updated_at          :datetime
#

require 'spec_helper'

describe CarModel do
  skip "add some examples to (or delete) #{__FILE__}"
end
