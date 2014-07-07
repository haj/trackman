class Plan < ActiveRecord::Base

	has_many :pricings
	has_and_belongs_to_many :features
	
	accepts_nested_attributes_for :pricings, :reject_if => :all_blank, :allow_destroy => true

end
