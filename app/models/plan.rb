class Plan < ActiveRecord::Base

	has_many :pricings

	accepts_nested_attributes_for :pricings, :reject_if => :all_blank, :allow_destroy => true

end
