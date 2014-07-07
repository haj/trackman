class Plan < ActiveRecord::Base

	accepts_nested_attributes_for :rules, :reject_if => :all_blank, :allow_destroy => true

end
