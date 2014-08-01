DeviceType.seed(:id,
  { id: 1, name: "DeviceType 1" },
  { id: 2, name: "DeviceType 2" },
  { id: 3, name: "DeviceType 3" }
)

DeviceModel.seed(:id,
  { id: 1, name: "DeviceModel A", device_manufacturer_id: 1, protocol: "Protocol1" },
  { id: 2, name: "DeviceModel Pro", device_manufacturer_id: 2, protocol: "Protocol2" },
  { id: 3, name: "DeviceModel Ultra", device_manufacturer_id: 2, protocol: "Protocol4" }
)

DeviceManufacturer.seed(:id,
  { id: 1, name: "DeviceManufacturer A" },
  { id: 2, name: "DeviceManufacturer Pro" },
  { id: 3, name: "DeviceManufacturer Ultra" }
)
