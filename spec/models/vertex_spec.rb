# == Schema Information
#
# Table name: vertices
#
#  id         :integer          not null, primary key
#  latitude   :float(24)
#  longitude  :float(24)
#  region_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#

require 'spec_helper'

describe Vertex do
  skip "add some examples to (or delete) #{__FILE__}"
end
