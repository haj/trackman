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
	scope :by_teleprovider, -> teleprovider_id { where(:teleprovider_id => teleprovider_id) }
	scope :available, -> { where(:device_id => nil) }
	scope :used, -> { where("device_id NOT NULL") }
	
	acts_as_paranoid

	validates :telephone_number, :teleprovider_id, :monthly_price, presence: true
	
	acts_as_tenant(:company)

	belongs_to :teleprovider
	belongs_to :device


	def self.available_simcards
		Simcard.where(:device_id => nil)
	end 

	def name
		return "#{self.id} #{self.telephone_number} (#{self.teleprovider.name})"
	end
end
