module OrdersHelper
  def driver_collection
    User.by_role(:driver).pluck(:first_name, :id)
  end

  def decline_label_helper(driver)    
    "; due to: #{driver.declined_order.reason}" if ['declined', 'canceled'].include?(driver.aasm_state)  
  end

  def order_action(order)
    _html = ""

    _html += link_to "Show", order, class: 'btn btn-mini btn-info'
 
    if current_user.has_any_role?(:driver)
      if order.des_state == 'pending'
        _html += "&nbsp;"
        _html += link_to 'Accept', accept_destinations_driver_path(order.destination_id), class: 'btn btn-mini btn-primary', method: :put
        _html += "&nbsp;" 
        _html += link_to 'Decline', "javascript:void(0);", class: 'btn btn-mini btn-danger btn-decline', data: { id: order.destination_id, notifid: order.notif_id }, id: "js-decline-#{order.destination_id}"
      end
    end

    return _html.html_safe
  end

  def state_helper(order)
    order = order.try(:des_state) ? order.des_state : order.aasm_state    
    order.titleize
  end
end
