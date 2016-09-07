module NotificationsHelper
	def notif_helper(notif)
		link_to order_path(notif.notificationable.order) do
			case notif.action
			when 'assigned'
					"Central Office just assigned you on a new order package"
		  when 'accepted'
		  	"#{notif.sender.full_name} just accepted order #{notif.notificationable.order.package}"
		  when 'declined'
		  	"#{notif.sender.full_name} just declined order #{notif.notificationable.order.package}"
			end		
		end
	end

	def accept_decine_helper(action, id, state)
		if action == 'assigned'
			if state == 'pending'
				a = ""
	      a += "&nbsp; &nbsp;" 
	      a += link_to 'Accept', accept_destinations_driver_path(id), class: 'btn btn-mini btn-primary', method: :put
	      a += "&nbsp;" 
	      a += link_to 'Decline', decline_destinations_driver_path(id), class: 'btn btn-mini btn-danger',
	      	method: 'put', data: { 
	      		id: id,
	      		confirm: 'Are you sure want to decline this package?', 
	      		type: 'warning',
	      		text: 'Provide a reason.'
	      	}
	    else
	    	" - <strong>#{state.titleize}</strong>".html_safe
	    end
		end				
	end
end
