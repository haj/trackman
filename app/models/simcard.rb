# == Schema Information
#
# Table name: simcards
#
#  id               :integer          not null, primary key
#  telephone_number :string(255)
#  teleprovider_id  :integer
#  monthly_price    :float(24)
#  device_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#  company_id       :integer
#  deleted_at       :datetime
#  name             :string(255)
#

class Simcard < ActiveRecord::Base
  # INIT GEM FILE
  acts_as_paranoid
  acts_as_tenant(:company)

  # SCOPE
  scope :by_teleprovider, -> teleprovider_id { where(:teleprovider_id => teleprovider_id) }
  scope :available, -> { where(:device_id => nil) }
  scope :used, -> { where("device_id NOT NULL") }
  
  # VALIDATION
  validates :telephone_number, :teleprovider_id, :monthly_price, presence: true
  
  # ASSOCIATION
  belongs_to :teleprovider
  belongs_to :device

  def name
    "#{self.id} #{self.telephone_number} (#{self.teleprovider.name})"
  end

  def self.available_simcards
    Simcard.where(:device_id => nil)
  end 
end
