module OrdersHelper
  def driver_collection
    User.by_role(:driver).pluck(:first_name, :id)
  end

  def decline_label_helper(driver)    
    "; due to: #{driver.declined_order.reason}" if driver.aasm_state == 'declined'
  end
end
