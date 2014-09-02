class Vertex < ActiveRecord::Base
	belongs_to :region

	acts_as_tenant(:company)
end
