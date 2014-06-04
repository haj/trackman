# == Schema Information
#
# Table name: parameters
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  data_type  :string(255)
#  rule_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Parameter do
  pending "add some examples to (or delete) #{__FILE__}"
end
