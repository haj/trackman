json.array!(@vertices) do |vertex|
  json.extract! vertex, :id, :latitude, :longitude, :region_id
  json.url vertex_url(vertex, format: :json)
end
