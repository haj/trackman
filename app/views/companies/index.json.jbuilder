json.array!(@companies) do |company|
  json.extract! company, :id, :name, :subdomain
  json.url company_url(company, format: :json)
end
