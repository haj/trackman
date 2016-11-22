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
  # INIT FROM GEM
  acts_as_paranoid
  acts_as_tenant(:company)

  # ASSOCIATION
  has_many :vertices, dependent: :destroy

  # VALIDATION
  validates :name, presence: true

  # Attr Accessor
  attr_accessor :vertices

  # Callback
  after_save :save_vertices

  # Save vertices after save a region
  def save_vertices
    if self.vertices.present?
      self.vertices['markers'].values.each do |vertex|
        Vertex.create(latitude: vertex['latitude'], longitude: vertex['longitude'], region_id: id)
      end
    end
  end

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
