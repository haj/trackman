json.array! @simcards do |simcard|
  	json.id simcard.id
	json.telephone_number simcard.telephone_number
    json.monthly_price simcard.monthly_price
    json.teleprovider_id simcard.teleprovider_id
end