Traccar::Position.all.each do |p|

  device = Device.find_by_emei(Traccar::Device.find(p.deviceId).uniqueId)

  p.location = Location.create(device_id: device.id, latitude: p.latitude,
    longitude: longitude, time: p.fixTime, speed: p.speed, valid_position: p.valid,
    position_id: p.id, status: nil)



end
