# == Schema Information
#
# Table name: states
#
#  id               :integer          not null, primary key
#  data             :boolean          default(FALSE)
#  movement         :boolean          default(FALSE)
#  authorized_hours :boolean          default(FALSE)
#  speed_limit      :boolean          default(FALSE)
#  long_hours       :boolean          default(FALSE)
#  long_pause       :boolean          default(FALSE)
#  car_id           :integer
#  created_at       :datetime
#  updated_at       :datetime
#  speed            :float            default(0.0)
#

class State < ActiveRecord::Base
	belongs_to :car
end
