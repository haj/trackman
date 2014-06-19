json.array!(@parameters) do |parameter|
  json.extract! parameter, :id, :name, :type, :rule_id
  json.url parameter_url(parameter, format: :json)
end
