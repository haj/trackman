json.array! @cars do |car|
  json.id car.id
  json.mileage car.mileage
  json.numberplate car.numberplate
  json.car_model_id car.car_model_id
  json.car_type_id car.car_type_id
  json.registration_no car.registration_no
  json.year car.year
  json.color car.color
  json.group_id car.group_id
end