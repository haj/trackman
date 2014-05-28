json.array!(@rules) do |rule|
  json.extract! rule, :id
  json.url rule_url(rule, format: :json)
end
