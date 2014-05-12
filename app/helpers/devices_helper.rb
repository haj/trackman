module DevicesHelper

	def no_available_simcards?
		if Simcard.available_simcards.count == 0 
			return true
		else 
			return false
		end
	end

	def list_available_simcards
		return select_tag('simcard_id', content_tag(:option,'Select Simcard ...', :value=>"")+options_from_collection_for_select(Simcard.available_simcards, 'id', 'name'))
	end

	def list_no_available_simcards
		return select_tag('simcard_id', content_tag(:option,'No available simcards', :value=>""))
	end

	def list_simcards_with_default(simcard)
		return select_tag('simcard_id', content_tag(:option, simcard.name, :value=> simcard.id )+options_from_collection_for_select(Simcard.available_simcards, 'id', 'name'))
	end

	 


end
