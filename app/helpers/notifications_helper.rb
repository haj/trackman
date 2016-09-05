module NotificationsHelper
	def notif_helper(action)
		if action == 'assigned'
			"Central Office just assigned you on a new order package"
		end		
	end

	def accept_decine_helper(action, id)
		if action == 'assigned'
			a = ""
      a += "&nbsp; &nbsp;" 
      a += link_to 'Accept', "", class: 'btn btn-mini btn-primary'
      a += "&nbsp;" 
      a += link_to 'Decline', decline_order_path(id), class: 'btn btn-mini btn-danger',
      	method: 'put', data: { 
      		id: id,
      		confirm: 'Are you sure want to decline this package?', 
      		type: 'warning',
      		text: 'Provide a reason.'
      	}
		end				
	end
end
