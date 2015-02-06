# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  deleted_at :datetime
#

require 'spec_helper'

describe Region do
  skip "add some examples to (or delete) #{__FILE__}"
end
