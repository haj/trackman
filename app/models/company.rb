class Company < ActiveRecord::Base

	before_save { |company| company.subdomain = company.subdomain.downcase }

	has_many :users

end
