module OrdersHelper
  def driver_collection
    User.by_role(:driver).pluck(:first_name, :id)
  end
end
