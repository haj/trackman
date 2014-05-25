class Condition < ActiveRecord::Base

	has_and_belongs_to_many :rules

	

end
