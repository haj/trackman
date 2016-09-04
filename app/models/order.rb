class Order < ActiveRecord::Base
	# Relationship
  belongs_to :xml_destination
  has_many :destinations_drivers
  has_many :users, through: :destinations_drivers

  # Nested attr
  accepts_nested_attributes_for :destinations_drivers, allow_destroy: true, reject_if: :all_blank  

  def accepted_user
  	destinations_drivers.find_by(aasm_state: "accept")  	
  end
end
