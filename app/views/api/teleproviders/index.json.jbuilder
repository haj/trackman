json.array! @teleproviders do |teleprovider|
  	json.id teleprovider.name
	json.name teleprovider.name
    json.apn teleprovider.apn
end