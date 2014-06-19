class Region < ActiveRecord::Base
	has_many :vertices, dependent: :destroy

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
