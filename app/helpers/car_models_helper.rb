module CarModelsHelper
  def all_car_models
    CarModel.all.collect {|a| [ a.name, a.id ] }
  end
end
