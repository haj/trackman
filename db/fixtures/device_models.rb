Teleprovider.seed(:id,
  { id: 1, name: "T-Mobile", apn: "apn1" },
  { id: 2, name: "Spring", apn: "apn2" },
  { id: 3, name: "AT&T", apn: "apn3" },
  { id: 4, name: "Verizon", apn: "apn4" }
)


DeviceModel.seed(:id,
  { id: 1, name: "DeviceModel A", device_manufacturer_id: 1, protocol: "Protocol1" },
  { id: 2, name: "DeviceModel Pro", device_manufacturer_id: 2, protocol: "Protocol2" },
  { id: 3, name: "DeviceModel Ultra", device_manufacturer_id: 4, protocol: "Protocol4" }
)
