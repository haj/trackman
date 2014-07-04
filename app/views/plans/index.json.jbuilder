json.array!(@plans) do |plan|
  json.extract! plan, :id, :name
  json.url plan_url(plan, format: :json)
end
