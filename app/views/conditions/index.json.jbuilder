json.array!(@conditions) do |condition|
  json.extract! condition, :id
  json.url condition_url(condition, format: :json)
end
