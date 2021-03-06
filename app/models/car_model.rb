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

class CarModel < ActiveRecord::Base
  # ASSOCIATION
  belongs_to :car_manufacturer
  has_many :cars

  # VALIDATION
  validates :name, :car_manufacturer_id, presence: true

  # SCOPE
  scope :by_car_manufacturer, -> car_manufacturer_id { where(car_manufacturer_id: car_manufacturer_id) }
end
