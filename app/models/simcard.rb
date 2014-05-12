class Simcard < ActiveRecord::Base
	scope :by_teleprovider, -> teleprovider_id { where(:teleprovider_id => teleprovider_id) }
	scope :available, -> { where(:device_id => nil) }
	scope :used, -> { where("device_id NOT NULL") }

	acts_as_tenant(:company)

	belongs_to :teleprovider
	belongs_to :device


	def self.available_simcards
		Simcard.where(:device_id => nil)
	end 

	def name
		return "##{self.id} #{self.telephone_no} (#{self.teleprovider.name})"
	end
end
