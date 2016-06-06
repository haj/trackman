# == Schema Information
#
# Table name: teleproviders
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  apn        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Teleprovider < ActiveRecord::Base
  has_many :simcards

  validates :name, :apn, presence: true
end
