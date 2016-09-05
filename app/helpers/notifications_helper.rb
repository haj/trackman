module NotificationsHelper
	def notif_helper(action)
		if action == 'assigned'
			"Central Office just assigned you on a new order package"
		end		
	end

	def accept_decine_helper(action)
		if action == 'assigned'
			a = ""
      a += "&nbsp; &nbsp;" 
      a += link_to 'Accept', "", class: 'btn btn-mini btn-primary'
      a += "&nbsp;" 
      a += link_to 'Decline', "", class: 'btn btn-mini btn-danger'
		end				
	end
end
