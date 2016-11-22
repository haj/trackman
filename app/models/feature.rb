# == Schema Information
#
# Table name: features
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  role       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Feature < ActiveRecord::Base
  # ASSOCIATION
  has_and_belongs_to_many :plan_types

  # validation
  validates :name, :role, presence: true
end
