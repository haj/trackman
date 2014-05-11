class Company < ActiveRecord::Base

	before_save { |company| company.subdomain = company.subdomain.downcase }

end
