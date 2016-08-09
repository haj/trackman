ready = ->
  $("#new_car").validate
    rules:
      'car[name]':
        required: true
      'car[numberplate]':
        required: true

  $("#new_device").validate
    rules:
      'device[name]':
        required: true
      'device[emei]':
        required: true
      'device[device_type_id]':
        required: true
      'device[device_model_id]':
        required: true

  $("#new_alarm").validate
    rules:
      'alarm[name]':
        required: true

  $("#new_simcard").validate
    rules:
      'simcard[telephone_number]':
        required: true
      'simcard[teleprovider_id]':
        required: true
      'simcard[monthly_price]':
        required: true

  $("#new_user").validate
    rules:
      'first_name':
        required: true
      'last_name':
        required: true
      'user[email]':
        required: true
      'default_role':
        required: true

$(document).ready(ready)
$(document).on('page:load', ready)