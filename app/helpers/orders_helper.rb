module OrdersHelper
  def driver_collection
    User.where(roles_mask: User.mask_for(:driver)).pluck(:first_name, :id)
  end
end
