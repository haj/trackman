CarManufacturer.seed(:id,
  { id: 1, name: "Audi" },
  { id: 2, name: "BMW" },
  { id: 3, name: "Mercedes-Benz" }, 
  { id: 4, name: "Toyota" },
)


CarModel.seed(:id,
  { id: 1, name: "Audi A2", car_manufacturer_id: 1 },
  { id: 2, name: "Audi A3", car_manufacturer_id: 1 },
  { id: 3, name: "Audi A4", car_manufacturer_id: 1 }
)
