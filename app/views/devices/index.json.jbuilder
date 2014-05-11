json.array!(@devices) do |device|
  json.extract! device, :id, :name, :emei, :cost_price
  json.url device_url(device, format: :json)
end
