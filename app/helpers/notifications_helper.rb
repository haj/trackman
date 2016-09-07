module NotificationsHelper
	def notif_helper(notif)
		link_to order_path(notif.notificationable.order_id) do
			case notif.action
			when 'assigned'
					"Central Office just assigned you on a new order package"
		  when 'accepted'
		  	"#{notif.sender.full_name} just accepted order #{notif.notificationable.order.package}"
		  when 'declined'
		  	"#{notif.sender.full_name} just declined order #{notif.notificationable.order.package} due to #{notif.notificationable.declined_order.reason}"
			end		
		end
	end

	def accept_decline_helper(action, id, state, notifid)
		if action == 'assigned'
			if state == 'pending'
				a = ""
	      a += "&nbsp; &nbsp;" 
	      a += link_to 'Accept', accept_destinations_driver_path(id), class: 'btn btn-mini btn-primary', method: :put
	      a += "&nbsp;" 
	      a += link_to 'Decline', "javascript:void(0);", class: 'btn btn-mini btn-danger btn-decline', data: { id: id, notifid: notifid }, id: "js-decline-#{id}"
	    else
	    	" - <strong>#{state.titleize}</strong>".html_safe
	    end
		end				
	end
end
