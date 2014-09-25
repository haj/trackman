# == Schema Information
#
# Table name: locations
#
#  id          :integer          not null, primary key
#  address     :string(255)
#  position_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Traccar::Location < ActiveRecord::Base
	belongs_to :position, :class_name => 'Traccar::Position'
end
