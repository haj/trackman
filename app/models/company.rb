class Company < ActiveRecord::Base

	before_save { |company| company.subdomain = company.subdomain.downcase }

	has_many :users, :dependent => :destroy 
	has_many :cars, :dependent => :destroy
	has_many :devices, :dependent => :destroy
	has_many :simcards, :dependent => :destroy
	has_many :groups, :dependent => :destroy

end
