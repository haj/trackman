class Group < ActiveRecord::Base
	has_many :cars
	acts_as_tenant(:company)

end
