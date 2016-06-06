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

class Vertex < ActiveRecord::Base
  belongs_to :region

  acts_as_tenant(:company)
end
