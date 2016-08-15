# == Schema Information
#
# Table name: parameters
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  data_type   :string(255)
#  rule_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#  description :string(255)
#

class Parameter < ActiveRecord::Base
  # ASSOCIATION
  belongs_to :rule

  # validation
  validates :rule_id, :name, presence: true
end
