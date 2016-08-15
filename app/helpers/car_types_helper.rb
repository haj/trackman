module CarTypesHelper
  def all_car_types
    CarType.all.collect {|a| [ a.name, a.id ] }
  end
end
