json.(@cars) do |car|
	json.id car.id
	json.type car.car_type.name
	json.name car.name
	json.numberplate car.numberplate
	json.last_location car.last_location
	json.last_seen car.last_seen
	json.speed car.speed
  json.lat car.last_latitude
  json.lon car.last_longitude
end
