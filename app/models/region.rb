# == Schema Information
#
# Table name: regions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  company_id :integer
#  deleted_at :datetime
#

class Region < ActiveRecord::Base
	has_many :vertices, dependent: :destroy
	acts_as_paranoid
	acts_as_tenant(:company)

	validates :name, presence: true

	# returns if point is inside a polygon
	def contains_point(latitude, longitude)
		points = []
		self.vertices.each do |vertex|
			points << Pinp::Point.new(vertex.latitude, vertex.longitude)
		end

		pgon = Pinp::Polygon.new(points)
		return pgon.contains_point? Pinp::Point.new(latitude, longitude)
	end

end
