ready = ->
  $("#form-car").validate
    rules:
      'car[name]':
        required: true
      'car[numberplate]':
        required: true

  $("#form-device").validate
    rules:
      'device[name]':
        required: true
      'device[emei]':
        required: true
      'device[device_type_id]':
        required: true
      'device[device_model_id]':
        required: true

  $("#form-alarm").validate
    rules:
      'alarm[name]':
        required: true

  $("#form-simcard").validate
    rules:
      'simcard[telephone_number]':
        required: true
      'simcard[teleprovider_id]':
        required: true
      'simcard[monthly_price]':
        required: true

  $("#form-users").validate
    rules:
      'first_name':
        required: true
      'last_name':
        required: true
      'user[email]':
        required: true
      'default_role':
        required: true

  $("#form-car-manufacture").validate
    rules:
      'car_manufacturer[name]':
        required: true

  $("#form-car-model").validate
    rules:
      'car_model[name]':
        required: true
      'car_model[car_manufacturer_id]':
        required: true

  $("#form-car-type").validate
    rules:
      'car_type[name]':
        required: true

  $("#form-device-manufacturer").validate
    rules:
      'device_manufacturer[name]':
        required: true

  $("#form-device-model").validate
    rules:
      'device_model[name]':
        required: true
      'device_model[device_manufacturer_id]':
        required: true
      'device_model[protocol]':
        required: true

  $("#form-device-type").validate
    rules:
      'device_type[name]':
        required: true

  $("#form-teleprovider").validate
    rules:
      'teleprovider[name]':
        required: true
      'teleprovider[apn]':
        required: true

  $("#form-rule").validate
    rules:
      'rule[name]':
        required: true
      'rule[method_name]':
        required: true

  $("#form-plan").validate
    rules:
      'plan[interval]':
        required: true
      'plan[price]':
        required: true
      'plan[currency]':
        required: true
      'plan[plan_type_id]':
        required: true

  $("#form-plan-type").validate
    rules:
      'plan_type[name]':
        required: true

  $("#form-feature").validate
    rules:
      'feature[name]':
        required: true

$(document).ready(ready)
$(document).on('page:load', ready)